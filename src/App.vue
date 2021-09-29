<template>
  <div id="app">
    <div class="container">
      <section class="section">
        <h1 class="title">ELRS Binding Phrase to UID Bytes</h1>

        <b-field label="Binding Phrase">
          <b-input v-model="textInput"></b-input>
        </b-field>

        <b-field label="Output">
          <b-input readonly type="text" expanded :value="uidBytesFromText" />

          <p class="control">
            <b-button label="Copy" type="is-primary" @click="copyUIDBytes" />
          </p>
        </b-field>

        <b-field label="Betaflight Command">
          <b-input readonly type="textarea" :value="betaflightCommand" />
        </b-field>

        <p class="control">
          <b-button
            label="Copy"
            type="is-primary"
            @click="copyBetaflightCommand"
          />
        </p>
      </section>
    </div>
  </div>
</template>

<script>
import CryptoJS from 'crypto-js';

function getBytesFromWordArray(wordArray) {
  const result = [];

  result.push(wordArray.words[0] >>> 24);
  result.push((wordArray.words[0] >>> 16) & 0xff);
  result.push((wordArray.words[0] >>> 8) & 0xff);
  result.push(wordArray.words[0] & 0xff);

  result.push(wordArray.words[1] >>> 24);
  result.push((wordArray.words[1] >>> 16) & 0xff);
  return result;
}

export default {
  name: 'App',
  metaInfo: {
    title: 'ELRS Binding Phrase to UID Bytes',
  },
  data() {
    return {
      textInput: '',
    };
  },
  computed: {
    uidBytesFromText() {
      const text = this.textInput;

      const bindingPhraseFull = `-DMY_BINDING_PHRASE="${text}"`;
      const bindingPhraseFullEncoded =
        CryptoJS.enc.Utf8.parse(bindingPhraseFull);

      const ciphertext = CryptoJS.MD5(bindingPhraseFullEncoded);
      const uidBytes = getBytesFromWordArray(ciphertext);

      return uidBytes;
    },
    betaflightCommand() {
      return `set expresslrs_uid ${this.uidBytesFromText}\nsave`;
    },
  },
  methods: {
    async copyUIDBytes() {
      await navigator.clipboard.writeText(this.uidBytesFromText);
      this.$buefy.toast.open('Copied UID Bytes.');
    },
    async copyBetaflightCommand() {
      await navigator.clipboard.writeText(this.betaflightCommand);
      this.$buefy.toast.open('Copied Betaflight command.');
    },
  },
};
</script>