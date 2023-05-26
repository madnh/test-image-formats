# test-image-formats

This repo try to test [image-set](https://developer.mozilla.org/en-US/docs/Web/CSS/image/image-set) feature on browsers.

Browsers:

- Safari 16.4
- Firefox 113
- Chrome 113 on both 2x and 1x resolution screen
- Chrome 112 on both 2x and 1x resolution screen

## Result

| Test 👇🏻 &nbsp;&nbsp;&nbsp; Browser 👉        | Safari           | Firefox  | Chrome <br/> 113 1x | Chrome <br/> 113 2x | Chrome <br/> 112 1x | Chrome <br/> 112 2x |
| -------------------------------------------- | ---------------- | -------- | ------------------- | ------------------- | ------------------- | ------------------- |
| `<image>` with many file types               | ✅               | ✅       | ✅                  | ✅                  | ✅                  | ✅                  |
| `<picture>` with many file types             | ✅               | ✅       | ✅                  | ✅                  | ✅                  | ✅                  |
| Background - Avif                            | ✅               | ✅       | ✅                  | ✅                  | ✅                  | ✅                  |
| Background - Webp                            | ✅               | ✅       | ✅                  | ✅                  | ✅                  | ✅                  |
| Background - Jpg with sizes                  | JPEG, webkit, 2x | JPEG, 2x | JPEG, 1x            | JPEG, 2x            | JPEG, webkit, 1x    | JPEG, webkit, 2x    |
| Background - Avif with sizes                 | AVIF, webkit, 2x | AVIF, 2x | AVIF, 1x            | AVIF, 2x            | AVIF, webkit, 1x    | AVIF, webkit, 2x    |
| Background - JPEG, 1 size 2x                 | JPEG, webkit, 2x | JPEG, 2x | JPEG, 2x            | JPEG, 2x            | JPEG, webkit, 2x    | JPEG, webkit, 2x    |
| Background - Multi types, not specified size | JPEG, webkit     | AVIF     | AVIF                | JPEG                | AVIF, webkit        | JPEG, webkit        |
| Background - Multi types, multi sizes        | AVIF, webkit, 2x | AVIF, 2x | AVIF                | AVIF, 2x            | AVIF, webkit        | AVIF, webkit, 2x    |
| Background - Multi types, 1 size 2x          | AVIF, webkit, 2x | AVIF, 2x | AVIF, 2x            | AVIF, 2x            | AVIF, webkit, 2x    | AVIF, webkit, 2x    |

### Result images

- [Safari](./result/Safari.jpeg)
- [Firefox](./result/Firefox.jpeg)
- [Chrome 113 1x](./result/Chrome_113_1x.jpeg)
- [Chrome 113 2x](./result/Chrome_113_2x.jpeg)
- [Chrome 112 1x](./result/Chrome_112_1x.jpeg)
- [Chrome 112 2x](./result/Chrome_112_2x.jpeg)

## Issues

### Safari

Safari only support `-webkit` prefix, in format:

```css
-webkit-image-set(
    url("....") [resolution],
    ...
)
```

### Resolution and multi image types

When use multi image types syntax, browers (except Firefox) will ONLY use high resolution images on high resolution screen, like rentina. Browser will search on `url` funcs to find first one which its support image type and resolution, if resolution is not matching its requirement then use next `url` func. If not found matching `url` then maybe use LAST one it found (chrome) or not show image (Safari emulator).

```css
// BAD
.bg {
  background: url(image.jpg);
  background: -webkit-image-set(
    url(image.webp),
    // use in 1x screen and support webp browser
    url(image.jpg) // use in 2x, 3x,... screen
  );
}
```

**Fix:**

Specified `2x` or use fallback image types at the end

```css
// FIXED - Specified 2x resolution
.bg {
  background: url(image.jpg);
  background: -webkit-image-set(
    url(image.webp) 2x,
    // use on any screens, include 1x, 2x, 3x...
    url(image.jpg) 2x // use on any screen which not support webp
  );
}

// FIXED - Use fallback image
.bg {
  background: url(image.jpg);
  background: -webkit-image-set(
    url(image.webp),
    // use on 1x screen if support webp image
    url(image.jpg),
    // use on 1x and not support webp
    url(image.webp) // use on any screen (Chrome)
  );
}
```

Note: since Safari support `image-set` in format of `url(...) [resolution]` then its better to use resolution fix

### Chrome

Fully support from ver 113. Before, use `-webkit` prefix.

## Summary

### 1. Always use fallbacks

- rules order: `url` -> `-webkit-image-set` -> `image-set`
- image types rule: modern file types -> safe file types, eg: `avif` -> `webp` -> `jpg`/`png`

### 2. Use 2x resolution

Use 2x resolution on EVERY `url` fns inside of `image-set` func, even if image is in 1x.

```css
-webkit-image-set(
    url(image.webp) 2x,
    url(image.jpg) 2x
)

image-set(
    url(image.webp) 2x type('image/webp'),
    url(image.jpg) 2x type('image/jpeg')
)
```

### 3. Resolution has a higher precedence than the file type

Browser will prefer to use high resolution image over supported image type.

```css
url(image-fallback.jpg);
image-set(
    url(image.avif) type('image/avif'),
    url(image.webp) type('image/webp'),
    url(image@2x.webp) 2x type('image/webp'),
    url(image.jpg) type('image/jpg'),
)
```

then:

- 1x screen:
  - `image.avif` or `image.webp` or `image.jpg`
- 2x screen:
  - `image@2x.webp` if support webp
  - `image-fallback.jpg` if not support webp

## Snippets

### Many sizes only

```css
#bg-image-set-multi-sizes {
  background-image: url(assets/image_fallback.jpg);

  background-image: -webkit-image-set(
    url(assets/image-webkit.jpg) 1x,
    url(assets/image-webkit@2x.jpg) 2x
  );

  background-image: image-set(
    url(assets/image.jpg) 1x type('image/jpeg'),
    url(assets/image@2x.jpg) 2x type('image/jpeg')
  );
}
```

### Many file types

```css
#bg-image-set-multi-types {
  background-image: url(assets/image_fallback.jpg);

  background-image: -webkit-image-set(
    url(assets/image-webkit.avif) 2x,
    url(assets/image-webkit.webp) 2x,
    url(assets/image-webkit.jpg) 2x
  );

  background-image: image-set(
    url(assets/image.avif) 2x type('image/avif'),
    url(assets/image.webp) 2x type('image/webp'),
    url(assets/image.jpg) 2x type('image/jpeg')
  );
}
```

### Many file types and sizes

```css
#bg-image-set-multi-types-and-sizes {
  background-image: url(assets/image_fallback.jpg);

  background-image: -webkit-image-set(
    url(assets/image-webkit.avif) 1x,
    url(assets/image-webkit@2x.avif) 2x,
    url(assets/image-webkit.webp) 1x,
    url(assets/image-webkit@2x.webp) 2x,
    url(assets/image-webkit.jpg) 1x,
    url(assets/image-webkit@2x.jpg) 2x
  );

  background-image: image-set(
    url(assets/image.avif) 2x type('image/avif'),
    url(assets/image@2x.avif) 2x type('image/avif'),
    url(assets/image.webp) 1x type('image/webp'),
    url(assets/image@2x.webp) 2x type('image/webp'),
    url(assets/image.jpg) 1x type('image/jpeg'),
    url(assets/image@2x.jpg) 2x type('image/jpeg')
  );
}
```

## Development

You can use [BrowserSync](https://browsersync.io) to auto reload test page and sync scroll between browsers.

### Replace image

This project use [ImageMagick](https://imagemagick.org/) to generate test images.

1. Replace `base.jpg` image with your new one
2. Run command: `bash make-image.sh`

## Licences

This repo use photo by <a href="https://unsplash.com/@akbarnemati?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Akbar Nemati</a> on <a href="https://unsplash.com/photos/0XdvHDbpozg?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Unsplash</a>
