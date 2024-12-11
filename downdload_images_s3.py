import boto3
import os
from typing import List


def download_images_from_s3(
    bucket_name: str, prefix: str, local_dir: str, num_images: int
) -> List[str]:
    """
    Download k images from an S3 bucket to a local directory

    Args:
        bucket_name: Name of the S3 bucket
        prefix: Prefix/folder path in the bucket to search for images
        local_dir: Local directory to save downloaded images
        num_images: Number of images to download

    Returns:
        List of local file paths of downloaded images
    """
    # Create S3 client
    s3_client = boto3.client("s3")

    # Create local directory if it doesn't exist
    os.makedirs(local_dir, exist_ok=True)

    # List objects in bucket with given prefix
    paginator = s3_client.get_paginator("list_objects_v2")
    pages = paginator.paginate(Bucket=bucket_name, Prefix=prefix)

    downloaded_files = []
    count = 0

    # Iterate through objects and download
    for page in pages:
        if "Contents" not in page:
            continue

        for obj in page["Contents"]:
            # Skip if not an image file
            if not obj["Key"].lower().endswith((".png", ".jpg", ".jpeg")):
                continue

            # Download file
            filename = os.path.basename(obj["Key"])
            local_path = os.path.join(local_dir, filename)

            s3_client.download_file(bucket_name, obj["Key"], local_path)
            downloaded_files.append(local_path)

            count += 1
            if count >= num_images:
                return downloaded_files

    return downloaded_files


if __name__ == "__main__":
    download_images_from_s3(
        bucket_name="scopesecure-prod",
        prefix="detections/organizations/8665721d-1a87-46f6-a940-5804754827d1/cameras/fd826e26-3085-4e20-8c44-b69bf28b7abc/",
        local_dir="/home/dns-harink/assets/test/fisheye_pov",
        num_images=20,
    )
