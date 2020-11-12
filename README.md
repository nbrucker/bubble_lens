# Bubble Lens
[![pub package](https://img.shields.io/pub/v/dart_jsonwebtoken.svg)](https://pub.dev/packages/bubble_lens)

A reproduction of the Apple Watch UI animation

## Example
<img src="https://github.com/nbrucker/bubble_lens/blob/main/example/example.gif?raw=true" width="320" height="700"/>

## Usage

### Import the package
```dart
import 'package:bubble_lens/bubble_lens.dart';
```

### Use the package

```dart
BubbleLens(
    width: 250,
    height: 250,
    widgets: [
        Container(
            width: 100,
            height: 100,
            color: Colors.red
        ),
        ...
    ]
);
```

## Required Parameters
| Prop          | Type          | Default                       | Description                           |
|---------------|---------------|-------------------------------|---------------------------------------|
| width         | double        | N/A                           | Width of the container.               |
| height        | double        | N/A                           | Height of the container.              |
| widgets       | List<Widget>  | N/A                           | List of widgets to display.           |
## Optional Parameters
| Prop          | Type          | Default                       | Description                           |
|---------------|---------------|-------------------------------|---------------------------------------|
| size          | double        | 100                           | Maximum size of a widget.             |
| paddingX      | double        | 10                            | Horizontal padding between widgets.   |
| paddingY      | double        | 0                             | Vertical padding between widgets.     |
| duration      | Duration      | Duration(milliseconds: 100)   | Animation's duration.                 |
| radius        | Radius        | Radius.circular(999)          | Widget's radius.                      |
| highRatio     | double        | 0                             | High ratio, should be >= 0.           |
| lowRatio      | double        | 0                             | Low ratio, should be >= 0.            |

## Example

Find the example wiring in the [Bubble Lens example application](https://github.com/nbrucker/bubble_lens/tree/main/example/lib/main.dart).

## Details

See the [bubble_lens.dart](https://github.com/nbrucker/bubble_lens/blob/main/lib/bubble_lens.dart) for more details.

## Issues and feedback

Please file [issues](https://github.com/nbrucker/bubble_lens/issues/new)
to send feedback or report a bug. Thank you!
