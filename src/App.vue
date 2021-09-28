<template>
  <div id="app">
    <div>Binding Phrase:</div>
    <input class="textInputs" type="text" v-model="textInput" />

    <br />
    <br />

    <div v-if="textInput !== ''">
      <div>Output:</div>
      <input
        class="textInputs"
        disabled
        type="text"
        :value="uidBytesFromText(textInput)"
      />
      <br />
      <input
        class="textInputs"
        disabled
        type="text"
        :value="`set expresslrs_uid ${uidBytesFromText(textInput)}`"
      />
    </div>
  </div>
</template>

<script>
import CryptoJS from 'crypto-js';

function getBytesFromWordArray(wordArray) {
  const result = [];

  result.push(wordArray.words[0] >>> 24);
  result.push((wordArray.words[0] >>> 16) & 0xFF);
  result.push((wordArray.words[0] >>> 8) & 0xFF);
  result.push(wordArray.words[0] & 0xFF)

  result.push(wordArray.words[1] >>> 24);
  result.push((wordArray.words[1] >>> 16) & 0xFF);

	return result;
}

function uidBytesFromText(text) {
  if (text === '') {
    return ''
  }

  const bindingPhraseFull = `-DMY_BINDING_PHRASE="${text}"`
  const bindingPhraseFullEncoded = CryptoJS.enc.Utf8.parse(bindingPhraseFull)

  const ciphertext = CryptoJS.MD5(bindingPhraseFullEncoded);
  const uidBytes = getBytesFromWordArray(ciphertext);

  return uidBytes
}

export default {
  name: 'App',
  data() {
    return {
      textInput: ''
    }
  },
  methods: {
    uidBytesFromText
  }
}
</script>

<style scoped>
.textInputs {
  width: 400px;
}
</style>