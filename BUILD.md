# Build Instructions

# Contents

- [Getting the source](#getting-the-source)
- [Linux](#linux)

# Getting the source

Clone the source code using git and grab all the submodules:

```
git clone https://github.com/Sneederix/SneedMC.git
cd SneedMC
git submodule init
git submodule update
```

The rest of the documentation assumes you have already cloned the repository.

# Linux

Getting the project to build and run on Linux is easy if you use any modern and up-to-date linux distribution.

## Build dependencies
- A C++ compiler capable of building C++11 code.
- Qt Development tools 5.6 or newer (`qtbase5-dev qtchooser qt5-qmake qtbase5-dev-tools libqt5core5a libqt5network5 libqt5gui5` on Debian-based system)
- cmake 3.1 or newer (`cmake` on Debian-based system)
- zlib (`zlib1g-dev` on Debian-based system)
- Java JDK (`openjdk-17-jdk`on Debian-based system)
- GL headers (`libgl1-mesa-dev` on Debian-based system)
- games/lwjgl port if using FreeBSD

You can use IDEs like KDevelop or QtCreator to open the CMake project if you want to work on the code.

### Building a portable binary

```sh
mkdir install
# configure the project
cmake -S . -B build \
   -DCMAKE_INSTALL_PREFIX=./install
# build
cd build
make -j$(nproc) install
```

### Building & Installing to the System

This is the preferred method for installation, and is suitable for packages.

```sh
# configure everything
cmake -S . -B build \
   -DCMAKE_BUILD_TYPE=Release \
   -DCMAKE_INSTALL_PREFIX="/usr" \ # Use "/usr" when building Linux packages. If building on FreeBSD or not for package, use "/usr/local"
   -DLauncher_LAYOUT=lin-system
cd build
make -j$(nproc) install # Optionally specify DESTDIR for packages (i.e. DESTDIR=${pkgdir})
```

### Building a flatpak

You don't need to clone the entire SneedMC repo for this; the flatpak file handles that.
`flatpak` and `flatpak-builder` need to be installed on your system

```sh
git clone https://github.com/flathub/org.sneederix.SneedMC
cd org.sneederix.SneedMC
# remove --user --install if you want to build without installing
flatpak-builder --user --install flatbuild org.sneederix.SneedMC.yml
```

### Installing Qt using the installer (optional)

1. Run the Qt installer.
2. Choose a place to install Qt.
3. Choose the components you want to install.
   - You need Qt 5.6.x 64-bit ticked.
   - You need Tools/Qt Creator ticked.
   - Other components are selected by default, you can untick them if you don't need them.
4. Accept the license agreements.
5. Double check the install details and then click "Install".
   - Installation can take a very long time, go grab a cup of tea or something and let it work.

### Loading the project in Qt Creator (optional)

1. Open Qt Creator.
2. Choose `File->Open File or Project`.
3. Navigate to the Launcher source folder you cloned and choose CMakeLists.txt.
4. Read the instructions that just popped up about a build location and choose one.
5. You should see "Run CMake" in the window.
   - Make sure that Generator is set to "Unix Generator (Desktop Qt 5.6.x GCC 64bit)".
   - Hit the "Run CMake" button.
   - You'll see warnings and it might not be clear that it succeeded until you scroll to the bottom of the window.
   - Hit "Finish" if CMake ran successfully.
6. Cross your fingers and press the Run button (bottom left of Qt Creator).
   - If the project builds successfully it will run and the Launcher window will pop up.

**If this doesn't work for you, sneed harder.**

# OpenBSD

Tested on OpenBSD 7.0-alpha i386, on older should work too

## Build dependencies
- A C++ compiler capable of building C++11 code (included in base system)
- Qt Development tools 5.6 or newer ([meta/qt5](https://openports.se/meta/qt5))
- cmake 3.1 or newer ([devel/cmake](https://openports.se/devel/cmake))
- zlib (included in base system)
- Java JDK ([devel/jdk-1.8](https://openports.se/devel/jdk/1.8))
- GL headers (included in base system)
- lwjgl ([games/lwjgl](https://openports.se/games/lwjgl) and [games/lwjgl3](https://openports.se/games/lwjgl3))

You can use IDEs like KDevelop or QtCreator to open the CMake project if you want to work on the code.

### Building a portable binary

```sh
mkdir install
# configure the project
cmake -S . -B build \
   -DCMAKE_INSTALL_PREFIX=./install -DCMAKE_PREFIX_PATH=/usr/local/lib/qt5/cmake
# build
cd build
make -j$(nproc) install
```

### Building & Installing to the System

This is the preferred method for installation, and is suitable for packages.

```sh
# configure everything
cmake -S . -B build \
   -DCMAKE_BUILD_TYPE=Release \
   -DCMAKE_INSTALL_PREFIX="/usr/local" \ # /usr/local is default in OpenBSD and FreeBSD
   -DLauncher_LAYOUT=lin-system -DCMAKE_PREFIX_PATH=/usr/local/lib/qt5/cmake # use linux layout and point to qt5 libs
cd build
make -j$(nproc) install # Optionally specify DESTDIR for packages (i.e. DESTDIR=${pkgdir})
```
