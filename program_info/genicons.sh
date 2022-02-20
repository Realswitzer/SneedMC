#/bin/bash

inkscape -w 16 -h 16 -o sneedmc_16.png org.sneederix.SneedMC.svg
inkscape -w 24 -h 24 -o sneedmc_24.png org.sneederix.SneedMC.svg
inkscape -w 32 -h 32 -o sneedmc_32.png org.sneederix.SneedMC.svg
inkscape -w 48 -h 48 -o sneedmc_48.png org.sneederix.SneedMC.svg
inkscape -w 64 -h 64 -o sneedmc_64.png org.sneederix.SneedMC.svg
inkscape -w 128 -h 128 -o sneedmc_128.png org.sneederix.SneedMC.svg

convert sneedmc_128.png sneedmc_64.png sneedmc_48.png sneedmc_32.png sneedmc_24.png sneedmc_16.png sneedmc.ico

inkscape -w 256 -h 256 -o sneedmc_256.png org.sneederix.SneedMC.svg
inkscape -w 512 -h 512 -o sneedmc_512.png org.sneederix.SneedMC.svg
inkscape -w 1024 -h 1024 -o sneedmc_1024.png org.sneederix.SneedMC.svg

png2icns sneedmc.icns sneedmc_1024.png sneedmc_512.png sneedmc_256.png sneedmc_128.png sneedmc_32.png sneedmc_16.png

rm -f sneedmc_*.png
rm -rf sneedmc.iconset

for dir in ../launcher/resources/*/scalable
do
    cp -v org.sneederix.SneedMC.svg $dir/launcher.svg
done
