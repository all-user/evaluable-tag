# evaluable-tag

The tag has evaluable attribute and it behaves like annotation to next sibling.


## install
```bash
npm install evaluable-tag
```

## usage

### in browser

```html
<script src="browser/et.js"></script>
<script>
  var ET = require('evaluable-tag');
</script>
```

### in browserify
```javascript
  var ET = require('evaluable-tag');
```

## ET#evalBy
html
```html
<span class="et" data-eval="1 + 2">sum</span>
```

javascript
```javascript
var evaluated = ET.evalBy('.et');

var et = evaluated[0];
console.log(et.result); // 3
console.log(et.annotation.textContent); // sum
console.log(et.annotated.textContent); // sum
```

## ET#evalAnnotationsBy
html
```html
<span class="et-a" data-eval="1 + 2">sum</span>
<div>content</div>
```

javascript
```javascript
var annotated = ET.evalAnnotationsBy('.et-a');

var et = annotated[0];
console.log(et.result); // 3
console.log(et.annotation.textContent); // sum
console.log(et.annotated.textContent); // content
```
