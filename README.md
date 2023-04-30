# whisper.spm

[whisper.cpp](https://github.com/ggerganov/whisper.cpp) package for the Swift Package Manager

## Using as a package in your project

In XCode: File -> Add Packages

Enter package URL: `https://github.com/ggerganov/whisper.spm`

<img width="1091" alt="image" src="https://user-images.githubusercontent.com/1991296/200189694-aed421ae-6fd7-4b17-8211-e43040c32e97.png">

## Build package from command line

```bash
git clone https://github.com/dotmain/whisper.spm.git
cd whisper.spm

set working directory to project directory
download models to models forlder

# if building standalone
make build

# if building as a submodule for whisper.cpp
make build-submodule

# run tests
.build/debug/test-objc

# run binary intelligence tests
.build/debug/test-swift
```

Binary Intelligence 
Enjoy! 

For testing purposes only. 
Not for commercial use. 

Please request licenses for commercial use with Mainvolume 
www.github.com/dotmain
www.github.com/mainvolume

Thank you.
