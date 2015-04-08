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

