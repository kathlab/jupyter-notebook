import torch

if torch.cuda.is_available():
    print("TORCH CUDA is available")
    print("TORCH CUDA device count: " + str(torch.cuda.device_count()))
    print("TORCH CUDA device name: " + torch.cuda.get_device_name(0))
else:
    print(":(")