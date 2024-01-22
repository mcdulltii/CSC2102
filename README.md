# CSC2102
SIT CSC2101 (Professional Software Development and Team Project 2)

# Installation on WSL2 (For Windows Systems)

## Requirements
1. Your Hyperviser is set to enable Windows Subsystem for Linux, otherwise see [here](https://learn.microsoft.com/en-us/windows/wsl/install) for me information on how to install WSL

2. An Nvidia GeForce GTX/RTX Graphics Processing Unit (GPU) or Graphics Card which is CUDA enabled

3. At least 16GB of RAM and a lot of swap space on disk

## Quick debugging checks
1. Run as admin in Windows Powershell, run wsl -l -v to check what sub-systems you have and ensure that they are version 2

2. Restart wsl by running ```wsl --shutdown``` and running it again or re-opening up Ubuntu (for example)

## Steps in wsl terminal
1. Run Windows Powershell and enter into your wsl -- OR Run a distro of your choice from the Microsoft Store (i.e Ubuntu)

2. Follow [these](https://developer.nvidia.com/cuda-downloads?target_os=Linux&target_arch=x86_64&Distribution=WSL-Ubuntu&target_version=2.0&target_type=deb_local) steps under the "> Base Installer" tab sequentially to install the necessary drivers to allow wsl to interface to your GPU

3. Run "nvidia-smi" on the terminal to confirm that the necessary drivers have been properly installed.

4. If your GPU details do not show up, it means you did not properly install the drivers, Go back to step 2. Else, visit Nvidia's website to install the [CUDA toolkit](https://developer.nvidia.com/cuda-downloads) and [cuDNN](https://developer.nvidia.com/cudnn) drivers from Nvidia directly and add them to your system PATH

5. Bring up Windows Powershell again and navigate yourself to the current User of the computer (i.e: C:\Users\Alice) folder and create a new file called [.wslconfig](./images/wslconfig_file.PNG)

6. Configure the amount of memory and swap space as required such that the model is able to properly fit within the physical constraints available to your hardware

7. Restart wsl by running ```wsl --shutdown```

## Configuration of wsl for running the server
1. wsl does not normally come with pip, do a quick installation:
``` 
sudo apt-get update 
sudo apt install python3-pip
```
2. With pip properly installed, the necessary required packages for the server to run the model are:
```
tensorflow
transformers
sentencepiece
accelerate
torch
```
3. Run the python file to start the server and load the model into memory

## Process termination debugging
1. Monitor the processes using task manager or ```top``` or ```htop```  to see whether there is enough RAM for the model to be loaded into memory
2. Check your .wslconfig on the memory configuration size
3. Make sure to restart your wsl by running ```wsl --shutdown```