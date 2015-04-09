assert = require 'power-assert'

describe 'evaluable tag', ->

  ET = require '../lib'
  div = document.createElement 'div'
  div.id = 'test-div'


  describe 'visibility check', ->
    it 'ET tag should be visible', ->
      document.body.appendChild div
      div.innerHTML = '''
        <span class="et" data-eval="{}">test 00</span>
      '''
      evaluated = ET.evalBy '.et'
      assert getComputedStyle(evaluated[0].annotation).lineHeight isnt '0px'
      assert getComputedStyle(evaluated[0].annotation).visibility is 'visible'

    it 'ET annotation should be hidden', ->
      document.body.appendChild div
      div.innerHTML = '''
        <span class="et" data-eval="{}">test 00</span>
      '''
      evaluated = ET.evalAnnotationsBy '.et'
      assert getComputedStyle(evaluated[0].annotation).lineHeight is '0px'
      assert getComputedStyle(evaluated[0].annotation).visibility is 'hidden'


  describe 'eval span', ->
    beforeEach 'clear test div', (done) ->
      div.innerHTML = ''
      done()

    it 'eval number', (done) ->
      div.innerHTML = '''
        <span class="et" data-eval="1024">test 01</span>
      '''
      evaluated = ET.evalBy '.et'
      for et in evaluated
        assert et.result is 1024
        assert et.annotation.textContent is 'test 01'
        assert et.annotated.textContent is 'test 01'
      done()


    it 'eval string', (done) ->
      document.body.appendChild div
      div.innerHTML = '''
        <span class="et" data-eval="'本日は晴天なり'">test 02</span>
      '''
      evaluated = ET.evalBy '.et'
      for et in evaluated
        assert et.result is '本日は晴天なり'
        assert et.annotation.textContent is 'test 02'
        assert et.annotated.textContent is 'test 02'
      done()

    it 'eval array', (done) ->
      document.body.appendChild div
      div.innerHTML = '''
        <span class="et" data-eval="[0, 1, 2, 3]">test 03</span>
      '''
      evaluated = ET.evalBy '.et'
      for et in evaluated
        assert.deepEqual et.result, [0, 1, 2, 3]
        assert et.annotation.textContent is 'test 03'
        assert et.annotated.textContent is 'test 03'
      done()

    it 'eval object', (done) ->
      document.body.appendChild div
      div.innerHTML = '''
        <span class="et" data-eval="{
          a: 'child',
          b: 'child',
          c: {
            d: 'nested child'
          }
        }">test 04</span>
      '''
      evaluated = ET.evalBy '.et'
      for et in evaluated
        assert.deepEqual et.result,
          a: 'child'
          b: 'child'
          c:
            d: 'nested child'
        assert et.annotation.textContent is 'test 04'
        assert et.annotated.textContent is 'test 04'
      done()

    it 'eval regexp', (done) ->
      document.body.appendChild div
      div.innerHTML = '''
        <span class="et" data-eval="/regexp*\\s+search\\s+test\\s*(?=finish)/">test 05</span>
      '''
      evaluated = ET.evalBy '.et'
      for et in evaluated
        assert et.result.test 'regex search test     finish'
        assert et.result.test 'regexppppppppp search   testfinish'
        assert et.annotation.textContent is 'test 05'
        assert et.annotated.textContent is 'test 05'
      done()

    it 'eval boolean', (done) ->
      document.body.appendChild div
      div.innerHTML = '''
        <span class="et" data-eval="true">test 06</span>
      '''
      evaluated = ET.evalBy '.et'
      for et in evaluated
        assert et.result is true
        assert et.annotation.textContent is 'test 06'
        assert et.annotated.textContent is 'test 06'
      done()

    it 'eval function object', (done) ->
      document.body.appendChild div
      div.innerHTML = '''
        <span class="et" data-eval="function testFunc(a, b) { return a + b; }">test 07</span>
      '''
      evaluated = ET.evalBy '.et'
      for et in evaluated
        a = Math.random()
        b = Math.random()
        assert et.result(a, b) is a + b
        assert et.result.name is 'testFunc'
        assert et.annotation.textContent is 'test 07'
        assert et.annotated.textContent is 'test 07'
      done()

    it 'eval function call', (done) ->
      document.body.appendChild div
      div.innerHTML = '''
        <span class="et" data-eval="Array.isArray([])">test 08</span>
      '''
      evaluated = ET.evalBy '.et'
      for et in evaluated
        assert et.result is true
        assert et.annotation.textContent is 'test 08'
        assert et.annotated.textContent is 'test 08'
      done()

    it 'eval immediately invoked function call', (done) ->
      document.body.appendChild div
      div.innerHTML = '''
        <span class="et" data-eval="
          (function(str) {
            return 'immediately ' + str + ' function test';
          })('invoked')
        ">test 09</span>
      '''
      evaluated = ET.evalBy '.et'
      for et in evaluated
        assert et.result is 'immediately invoked function test'
        assert et.annotation.textContent is 'test 09'
        assert et.annotated.textContent is 'test 09'
      done()

    it 'readme example test: evalBy', (done) ->
      div.innerHTML = '''
        <span class="et" data-eval="1 + 2">sum</span>
      '''
      evaluated = ET.evalBy '.et'
      et = evaluated[0]
      assert et.result is 3
      assert et.annotation.textContent is 'sum'
      assert et.annotated.textContent is 'sum'
      done()


  describe 'eval annotation', ->

    it 'with sibling element', (done) ->
      document.body.appendChild div
      div.innerHTML = '''
        <span class="et-a" data-eval="'annotation test'">test 10: annotation</span>
        <span>test 10: annotated</span>
      '''
      evaluated = ET.evalAnnotationsBy '.et-a'
      for et in evaluated
        assert et.result is 'annotation test'
        assert et.annotation.textContent is 'test 10: annotation'
        assert et.annotated.textContent is 'test 10: annotated'
      done()

    it 'without sibling element', (done) ->
      document.body.appendChild div
      div.innerHTML = '''
        <span class="et-a" data-eval="'annotation test'">test 11: annotation</span>
      '''
      evaluated = ET.evalAnnotationsBy '.et-a'
      for et in evaluated
        assert et.result is 'annotation test'
        assert et.annotation.textContent is 'test 11: annotation'
        assert et.annotated is null
      done()

    it 'readme example test: evalAnnotationsBy', (done) ->
      div.innerHTML = '''
        <span class="et-a" data-eval="1 + 2">sum</span>
        <div>content</div>
      '''
      annotated = ET.evalAnnotationsBy '.et-a'

      et = annotated[0]
      assert et.result is 3
      assert et.annotation.textContent is 'sum'
      assert et.annotated.textContent is 'content'
      done()
