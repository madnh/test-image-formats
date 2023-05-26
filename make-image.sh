#!/usr/bin/env bash

function addText(){
  local resultImage=$1
  local text=$2
  local resultImageFile="assets/$resultImage"

  echo "$resultImage <- $text"

  convert -fill white \
    -family Arial \
    -weight DemiBold \
    -gravity Center \
    -pointsize 150 \
    -annotate +0+0 "$text" \
    -resize 500x500\> \
    base.jpg "${resultImageFile}"
}

# Base
# ---------------------------------------
addText image.jpg "JPEG"
addText image_fallback.jpg "JPEG\nFallback"
addText image.webp "WEBP"
addText image.avif "AVIF"

# Base + 2x
# ---------------------------------------
addText image@2x.jpg "JPEG\n2x"
addText image_fallback@2x.jpg "JPEG\nFallback\n2x"
addText image@2x.webp "WEBP\n2x"
addText image@2x.avif "AVIF\n2x"

# Base + -webkit prefix
# ---------------------------------------
addText image-webkit.jpg "JPEG\n-webkit"
addText image_fallback-webkit.jpg "JPEG\nFallback\n-webkit"
addText image-webkit.webp "WEBP\n-webkit"
addText image-webkit.avif "AVIF\n-webkit"

# Base + -webkit prefix + 2x
# ---------------------------------------
addText image-webkit@2x.jpg "JPEG\n-webkit\n2x"
addText image_fallback-webkit@2x.jpg "JPEG\nFallback\n-webkit\n2x"
addText image-webkit@2x.webp "WEBP\n-webkit\n2x"
addText image-webkit@2x.avif "AVIF\n-webkit\n2x"
