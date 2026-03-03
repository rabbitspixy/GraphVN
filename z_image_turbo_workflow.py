import json
import os
import random
import sys
from typing import Sequence, Mapping, Any, Union
import torch
from PIL import Image

"""
[
    {
        "prompt": "image description prompt",
        "outputFile": "path/to/file/1.jpg",
    },
    {
        "prompt": "second image description prompt",
        "outputFile": "path/to/file/2.jpg",
    }
]
"""
data = json.load(sys.stdin)
print(f'DATA={data}')

GENERATION_STEPS = 30


def get_value_at_index(obj: Union[Sequence, Mapping], index: int) -> Any:
    """Returns the value at the given index of a sequence or mapping.

    If the object is a sequence (like list or string), returns the value at the given index.
    If the object is a mapping (like a dictionary), returns the value at the index-th key.

    Some return a dictionary, in these cases, we look for the "results" key

    Args:
        obj (Union[Sequence, Mapping]): The object to retrieve the value from.
        index (int): The index of the value to retrieve.

    Returns:
        Any: The value at the given index.

    Raises:
        IndexError: If the index is out of bounds for the object and the object is not a mapping.
    """
    try:
        return obj[index]
    except KeyError:
        return obj["result"][index]


def find_path(name: str, path: str = None) -> str:
    """
    Recursively looks at parent folders starting from the given path until it finds the given name.
    Returns the path as a Path object if found, or None otherwise.
    """
    # If no path is given, use the current working directory
    if path is None:
        path = os.getcwd()

    # Check if the current directory contains the name
    if name in os.listdir(path):
        path_name = os.path.join(path, name)
        print(f"{name} found: {path_name}")
        return path_name

    # Get the parent directory
    parent_directory = os.path.dirname(path)

    # If the parent directory is the same as the current directory, we've reached the root and stop the search
    if parent_directory == path:
        return None

    # Recursively call the function with the parent directory
    return find_path(name, parent_directory)


def add_comfyui_directory_to_sys_path() -> None:
    """
    Add 'ComfyUI' to the sys.path
    """
    comfyui_path = find_path("ComfyUI")
    if comfyui_path is not None and os.path.isdir(comfyui_path):
        sys.path.append(comfyui_path)
        print(f"'{comfyui_path}' added to sys.path")


def add_extra_model_paths() -> None:
    """
    Parse the optional extra_model_paths.yaml file and add the parsed paths to the sys.path.
    """
    try:
        from main import load_extra_path_config
    except ImportError:
        print(
            "Could not import load_extra_path_config from main.py. Looking in utils.extra_config instead."
        )
        from utils.extra_config import load_extra_path_config

    extra_model_paths = find_path("extra_model_paths.yaml")

    if extra_model_paths is not None:
        load_extra_path_config(extra_model_paths)
    else:
        print("Could not find the extra_model_paths config file.")


add_comfyui_directory_to_sys_path()
add_extra_model_paths()


def import_custom_nodes() -> None:
    """Find all custom nodes in the custom_nodes folder and add those node objects to NODE_CLASS_MAPPINGS

    This function sets up a new asyncio event loop, initializes the PromptServer,
    creates a PromptQueue, and initializes the custom nodes.
    """
    import asyncio
    import execution
    from nodes import init_extra_nodes

    sys.path.insert(0, find_path("ComfyUI"))
    import server

    # Creating a new event loop and setting it as the default loop
    loop = asyncio.new_event_loop()
    asyncio.set_event_loop(loop)

    # Creating an instance of PromptServer with the loop
    server_instance = server.PromptServer(loop)
    execution.PromptQueue(server_instance)

    # Initializing custom nodes
    asyncio.run(init_extra_nodes())


from nodes import NODE_CLASS_MAPPINGS
import folder_paths


def main():
    import_custom_nodes()
    with torch.inference_mode():
        # Load models once
        vaeloader = NODE_CLASS_MAPPINGS["VAELoader"]()
        vaeloader_5 = vaeloader.load_vae(vae_name="ae.safetensors")

        unetloader = NODE_CLASS_MAPPINGS["UNETLoader"]()
        unetloader_7 = unetloader.load_unet(
            unet_name="z_image_turbo_fp8_e4m3fn.safetensors", weight_dtype="fp8_e4m3fn"
        )

        emptylatentimage = NODE_CLASS_MAPPINGS["EmptyLatentImage"]()

        cliploader = NODE_CLASS_MAPPINGS["CLIPLoader"]()
        cliploader_12 = cliploader.load_clip(
            clip_name="qwen3_4b_fp8_scaled.safetensors",
            type="lumina2",
            device="default",
        )

        cliptextencode = NODE_CLASS_MAPPINGS["CLIPTextEncode"]()

        modelsamplingauraflow = NODE_CLASS_MAPPINGS["ModelSamplingAuraFlow"]()
        conditioningzeroout = NODE_CLASS_MAPPINGS["ConditioningZeroOut"]()
        ksampler = NODE_CLASS_MAPPINGS["KSampler"]()
        vaedecode = NODE_CLASS_MAPPINGS["VAEDecode"]()
        saveimage = NODE_CLASS_MAPPINGS["SaveImage"]()

        output_dir = folder_paths.get_output_directory()

        # Process each item from input data
        for item in data:
            prompt = item["prompt"]
            output_file = item["outputFile"]
            
            print(f"Processing prompt: {prompt[:50]}...")
            print(f"Output will be saved to: {output_file}")

            # Create latent image
            emptylatentimage_9 = emptylatentimage.generate(
                width=1536, height=864, batch_size=1
            )

            # Encode the prompt
            cliptextencode_11 = cliptextencode.encode(
                text=prompt,
                clip=get_value_at_index(cliploader_12, 0),
            )

            modelsamplingauraflow_8 = modelsamplingauraflow.patch_aura(
                shift=7, model=get_value_at_index(unetloader_7, 0)
            )

            conditioningzeroout_10 = conditioningzeroout.zero_out(
                conditioning=get_value_at_index(cliptextencode_11, 0)
            )

            ksampler_6 = ksampler.sample(
                seed=random.randint(1, 2**64),
                steps=GENERATION_STEPS,
                cfg=1,
                sampler_name="res_multistep",
                scheduler="simple",
                denoise=1,
                model=get_value_at_index(modelsamplingauraflow_8, 0),
                positive=get_value_at_index(cliptextencode_11, 0),
                negative=get_value_at_index(conditioningzeroout_10, 0),
                latent_image=get_value_at_index(emptylatentimage_9, 0),
            )

            vaedecode_2 = vaedecode.decode(
                samples=get_value_at_index(ksampler_6, 0),
                vae=get_value_at_index(vaeloader_5, 0),
            )

            # Save the image with a temporary prefix
            saveimage_1 = saveimage.save_images(
                filename_prefix="Temp", images=get_value_at_index(vaedecode_2, 0)
            )

            print(f'saveimage_1 type = ${type(saveimage_1)} value = ${saveimage_1}')

            # Get the saved file info
            saved_info = saveimage_1['ui']['images'][0]
            filename = saved_info["filename"]
            subfolder = saved_info.get("subfolder", "")
            
            # Construct the full path to the saved file
            if subfolder:
                temp_file_path = os.path.join(output_dir, subfolder, filename)
            else:
                temp_file_path = os.path.join(output_dir, filename)

            # Create output directory if it doesn't exist
            os.makedirs(os.path.dirname(output_file), exist_ok=True)

            with Image.open(temp_file_path) as img:
                rgb_img = img.convert('RGB')
                rgb_img.save(output_file, 'JPEG', quality=90)
            
            # Move the file to the desired location
            # os.rename(temp_file_path, output_file)
            print(f"Image saved to {output_file}\n")


if __name__ == "__main__":
    main()