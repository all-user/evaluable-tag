# evaluable-tag

The tag has evaluable attribute and it behaves like annotation to next sibling.
used in conjuction with the browserify.

```html
<body>

<span class="et" data-eval="'this is embedded'">case string</span>
<span class="et" data-eval="1 * 2 * 3 * 4">case number</span>

<span class="et-a" data-eval="{
  a: true,
  b: 'string',
  c: 42
}">this is annotation</span>
<p>annotated tag</p>

<script src="./browser/build.js"></script>
<script>
    var ET = require('evaluable-tag');

    document.addEventListener('DOMContentLoaded', function() {

        // ET#evalBy
        var evaluated = ET.evalBy('.et');

        evaluated.forEach(function(et) {
            console.log('result     ->', et.result);
            console.log('annotation ->', et.annotation.textContent);
            console.log('annotated  ->', et.annotated.textContent);
        });

        // result     -> this is embedded
        // annotation -> case string
        // annotated  -> case string
        // result     -> 24
        // annotation -> case number
        // annotated  -> case number


        // ET#evalAnnotationsBy
        annotated = ET.evalAnnotationsBy('.et-a');

        annotated.forEach(function(et) {
            console.log('result     ->', et.result);
            console.log('annotation ->', et.annotation.textContent);
            console.log('annotated  ->', et.annotated.textContent);
        });

        // result     -> Object
        //                  a: true
        //                  b: "string"
        //                  c: 42
        // annotation -> this is annotation (test.html, line 26)
        // annotated  -> annotated tag (test.html, line 27)

    });
</script>

</body>
```
