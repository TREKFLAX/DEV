(function() {
'use strict';

Vue.component('message', {
  template: '#message_template',
  data: function() { return {}; },
  computed: {
    classes: function() {
      var CONFIG = window.CONFIG || {};
      var tc = (CONFIG && CONFIG.templateClasses) || {};
      return tc[this.templateId] || {
        wrapper: 'chat-message-layout',
        header: 'message-header',
        label: 'message-header-label',
        author: 'message-header-id',
        body: 'player-message'
      };
    },
    label: function() {
      if (this.messageLabel != null && this.messageLabel !== '') return this.messageLabel;
      var CONFIG = window.CONFIG || {};
      var labels = (CONFIG && CONFIG.templateLabels) || {};
      return labels[this.templateId] || this.templateId;
    },
    authorDisplay: function() {
      if (!this.classes || this.classes.author === '') return null;
      var hd = this.headerDisplay === 1 ? 1 : 0;
      var val = this.args[hd];
      return val != null ? String(val) : null;
    },
    messageBody: function() {
      var text = this.args[2] != null ? String(this.args[2]) : '';
      return this.bodyHtml(text);
    },
    headerStyle: function() {
      var c = this.normalizeColor(this.color);
      var rgb = c[0] + ',' + c[1] + ',' + c[2];
      return {
        backgroundColor: 'rgba(' + rgb + ',0.35)',
        borderColor: 'rgba(' + rgb + ',0.5)',
        color: 'rgb(' + rgb + ')'
      };
    }
  },
  methods: {
    normalizeColor: function(color) {
      var def = [255, 255, 175];
      if (!color) return def;
      if (typeof color === 'string' && color.indexOf('#') === 0) {
        var hex = color.replace(/^#/, '');
        if (hex.length === 6) {
          return [
            parseInt(hex.substr(0, 2), 16),
            parseInt(hex.substr(2, 2), 16),
            parseInt(hex.substr(4, 2), 16)
          ];
        }
      }
      var arr = Array.isArray(color) ? color : (color[1] != null && color[2] != null ? [color[1], color[2], color[3]] : null);
      if (arr && arr.length >= 3) return [Number(arr[0]) || 255, Number(arr[1]) || 255, Number(arr[2]) || 175];
      if (typeof color === 'object' && color !== null) {
        var r = Number(color[0] != null ? color[0] : color['1'] != null ? color['1'] : color.r) || 255;
        var g = Number(color[1] != null ? color[1] : color['2'] != null ? color['2'] : color.g) || 255;
        var b = Number(color[2] != null ? color[2] : color['3'] != null ? color['3'] : color.b) || 175;
        return [r, g, b];
      }
      return def;
    },
    bodyHtml: function(str) {
      if (str == null) return '';
      var escaped = this.escape(String(str));
      return this.colorize(escaped);
    },
    colorize: function(str) {
      var s = "<span>" + (str.replace(/\^([0-9])/g, function() { return "</span><span>"; })) + "</span>";
      var styleDict = { '*': 'font-weight: bold;', '_': 'text-decoration: underline;', '~': 'text-decoration: line-through;', '=': 'text-decoration: underline line-through;', 'r': 'text-decoration: none;font-weight: normal;' };
      var styleRegex = /\^(\_|\*|\=|\~|\/|r)(.*?)(?=$|\^r|<\/em>)/;
      while (s.match(styleRegex)) {
        s = s.replace(styleRegex, function(_, style, inner) { return '<em style="' + styleDict[style] + '">' + inner + '</em>'; });
      }
      return s.replace(/<span[^>]*><\/span[^>]*>/g, '');
    },
    escape: function(unsafe) {
      if (this.templateId === 'warning' || this.templateId === 'system') return String(unsafe);
      var text = String(unsafe);
      if (text.startsWith('/')) {
        return text.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;').replace(/'/g, '&#039;');
      }
      return text.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;').replace(/'/g, '&#039;').replace(/[\u2039\u203A\u00AB\u00BB\u2329\u232A\u27E8\u27E9\u3008\u3009\uFE3F\uFE40]/g, '?');
    }
  },
  props: {
    templates: { type: Object },
    args: { type: Array },
    template: { type: String, default: null },
    templateId: { type: String, default: function() { return (window.CONFIG && window.CONFIG.defaultTemplateId) || 'default'; } },
    headerDisplay: { type: Number, default: 0 },
    messageLabel: { type: String, default: null },
    multiline: { type: Boolean, default: false },
    color: { type: Array, default: false },
    bgcolor: { type: Array, default: false }
  }
});

function filterMatchingSuggestions(message, suggestionsList) {
  if (!message) return [];
  return suggestionsList.filter(function(s) {
    if (!s.name.startsWith(message)) {
      var suggestionSplitted = s.name.split(' ');
      var messageSplitted = message.split(' ');
      var paramsLen = (Array.isArray(s.params) && s.params.length) || 0;
      for (var i = 0; i < messageSplitted.length; i++) {
        if (i >= suggestionSplitted.length) return i < suggestionSplitted.length + paramsLen;
        if (suggestionSplitted[i] !== messageSplitted[i]) return false;
      }
    }
    return true;
  });
}

Vue.component('suggestions', {
  template: '#suggestions_template',
  props: ['message', 'suggestions'],
  data: function() { return {}; },
  methods: {
    applySuggestion: function(suggestion) { this.$emit('apply-suggestion', suggestion); },
    hasHelp: function(s) {
      if (s.help) return true;
      if (!s.params || !s.params.length) return false;
      for (var i = 0; i < s.params.length; i++) {
        if (s.params[i].help) return true;
      }
      return false;
    }
  },
  computed: {
    currentSuggestions: function() {
      if (this.message === '') return [];
      var self = this;
      var limit = (window.CONFIG && window.CONFIG.suggestionLimit) || 5;
      var list = filterMatchingSuggestions(this.message, this.suggestions).slice(0, limit);
      list.forEach(function(s) {
        s.disabled = !s.name.startsWith(self.message);
        s.params.forEach(function(p, index) {
          var wType = (index === s.params.length - 1) ? '.' : '\\S';
          var regex = new RegExp(s.name + ' (?:\\w+ ){' + index + '}(?:' + wType + '*)$', 'g');
          var match = self.message.match(regex);
          p.disabled = match == null;
          p.active = match != null;
        });
      });
      return list;
    }
  }
});

window.APP = {
  template: '#app_template',
  name: 'app',
  data: function() {
    return {
      style: (window.CONFIG && window.CONFIG.style) || {},
      showInput: false,
      showWindow: false,
      showMessages: true,
      shouldHide: true,
      labels: {},
      locale: null,
      backingSuggestions: [],
      removedSuggestions: [],
      templates: (window.CONFIG && window.CONFIG.templates) || {},
      message: '',
      messages: [],
      storedMessages: [],
      oldMessages: [],
      oldMessagesIndex: -1,
      tplBackups: [],
      msgTplBackups: [],
      showSettings: false,
      inputPosition: (window.CONFIG && window.CONFIG.defaultPositions) ? { x: window.CONFIG.defaultPositions.input.x, y: window.CONFIG.defaultPositions.input.y } : { x: 0.8, y: 2 },
      messagesPosition: (window.CONFIG && window.CONFIG.defaultPositions) ? { x: window.CONFIG.defaultPositions.messages.x, y: window.CONFIG.defaultPositions.messages.y } : { x: 0.8, y: 1.5 },
      baselineInputY: (window.CONFIG && window.CONFIG.defaultPositions) ? window.CONFIG.defaultPositions.input.y : 2,
      baselineMessagesY: (window.CONFIG && window.CONFIG.defaultPositions) ? window.CONFIG.defaultPositions.messages.y : 1.5,
      baselineInputX: (window.CONFIG && window.CONFIG.defaultPositions) ? window.CONFIG.defaultPositions.input.x : 1,
      baselineMessagesX: (window.CONFIG && window.CONFIG.defaultPositions) ? window.CONFIG.defaultPositions.messages.x : 0.8,
      fontWeight: 300,
      limitEnabled: true,
      maxLength: 100,
      meDo3DNUIEnabled: false,
      worldMeDoBubbles: []
    };
  },
  destroyed: function() {
    clearInterval(this.focusTimer);
    window.removeEventListener('message', this.listener);
    if (this._escHandler) window.removeEventListener('keydown', this._escHandler);
  },
  mounted: function() {
    try { localStorage.removeItem('chatMessageHistory'); } catch (e) {}
    post('http://jc_chat/loaded', JSON.stringify({}));
    var self = this;
    this.listener = window.addEventListener('message', function(event) {
      var item = event.data || event.detail;
      if (self[item.type]) self[item.type](item);
    });
    this.loadSettings();
    this.loadMessageHistory();
    this._escHandler = function(e) {
      var isEsc = (e.key === 'Escape' || e.which === 27);
      if (!isEsc) return;
      if (self.showSettings) { e.preventDefault(); self.toggleSettings(); return; }
      if (self.showInput) { e.preventDefault(); self.hideInput(true); return; }
    };
    window.addEventListener('keydown', this._escHandler);
    setTimeout(function() {
      try {
        var hasLabels = self.labels && Object.keys(self.labels).length > 0;
        if (!hasLabels) post('http://jc_chat/requestLocale', JSON.stringify({}));
      } catch (e) {}
    }, 800);
  },
  watch: {
    messages: function() {
      if (this.showWindowTimer) clearTimeout(this.showWindowTimer);
      this.showWindow = true;
      this.storedMessages = this.messages.slice();
      this.resetShowWindowTimer();
      var messagesObj = this.$refs.messages;
      this.$nextTick(function() { messagesObj.scrollTop = messagesObj.scrollHeight; });
    }
  },
  computed: {
    suggestions: function() {
      return this.backingSuggestions.filter(function(el) {
        if (this.removedSuggestions.indexOf(el.name) > -1) return false;
        if (Array.isArray(el.params) && el.params.length > 0) el.paramsText = el.params.join(' ');
        else el.paramsText = '';
        return true;
      }.bind(this));
    },
    charCount: function() {
      var msg = this.message || '';
      if (this.isSlashMe(msg)) return this.getMeBody(msg).length;
      return msg.length;
    }
  },
  methods: {
    ON_CLEAR_HISTORY: function() { try { localStorage.removeItem('chatMessageHistory'); this.oldMessages = []; this.oldMessagesIndex = -1; } catch (e) {} },
    ON_LOCALE: function(payload) {
      if (payload.labels && typeof payload.labels === 'object') { this.labels = payload.labels; this.applyLocaleTemplates(); return; }
      if (typeof payload.labelsJson === 'string' && payload.labelsJson.length > 0) {
        try {
          var parsed = JSON.parse(payload.labelsJson);
          if (parsed && typeof parsed === 'object') { this.labels = parsed; this.applyLocaleTemplates(); }
        } catch (e) { console.warn('Error parsing labelsJson:', e); }
      }
    },
    applyLocaleTemplates: function() {
      try {
        var H = (this.labels && this.labels.headers) || {};
        var base = (window.CONFIG && window.CONFIG.templates) ? window.CONFIG.templates : {};
        var localized = Object.assign({}, base);
        Object.keys(base).forEach(function(tpl) {
          var html = base[tpl];
          if (H && typeof H === 'object') {
            html = html.replace(/(class="[\w-]*header">)([^<\-]+)([ -]*)(\[?\{?\d*\}?\]?\)?)/i, function(match, p1, p2, p3, p4) {
              if (H[tpl]) return p1 + H[tpl] + p3 + (p4 || '');
              return match;
            });
          }
          localized[tpl] = html;
        });
        this.templates = localized;
      } catch (e) { console.warn('applyLocaleTemplates error:', e); }
    },
    t: function(key) {
      try {
        var parts = String(key || '').split('.');
        var cur = this.labels || {};
        for (var i = 0; i < parts.length; i++) {
          if (cur && Object.prototype.hasOwnProperty.call(cur, parts[i])) cur = cur[parts[i]];
          else return key;
        }
        return (typeof cur === 'string') ? cur : key;
      } catch (e) { return key; }
    },
    ON_SCREEN_STATE_CHANGE: function(payload) { this.shouldHide = payload.shouldHide; },
    ON_OPEN: function() {
      this.showInput = true;
      this.showWindow = true;
      this.showMessages = true;
      if (this.storedMessages.length > 0) this.messages = this.storedMessages.slice();
      if (this.showWindowTimer) clearTimeout(this.showWindowTimer);
      var self = this;
      this.$nextTick(function() {
        var chatMessages = document.querySelector('.chat-messages');
        if (chatMessages) {
          chatMessages.classList.add('slide-in-left');
          setTimeout(function() { chatMessages.classList.remove('slide-in-left'); }, 260);
        }
      });
      this.$nextTick(function() {
        if (self.$refs.input) {
          self.$refs.input.focus();
          var len = self.$refs.input.value.length;
          self.$refs.input.setSelectionRange(len, len);
          try {
            var draft = localStorage.getItem('chatDraft');
            if (typeof draft === 'string') { self.message = draft; self.resize(); }
          } catch (err) {}
        }
      });
      this.$nextTick(function() { self.updateChatPosition(); });
      this.focusTimer = setInterval(function() {
        if (this.$refs.input) {
          this.$refs.input.focus();
          var l = this.$refs.input.value.length;
          this.$refs.input.setSelectionRange(l, l);
          clearInterval(this.focusTimer);
        } else clearInterval(this.focusTimer);
      }.bind(this), 100);
    },
    sanitizeHtml: function(text) {
      if (!text) return text;
      return String(text).replace(/</g, '&lt;').replace(/>/g, '&gt;');
    },
    sanitizeArgs: function(args) {
      if (!args || !Array.isArray(args)) return args;
      var self = this;
      return args.map(function(arg) {
        if (typeof arg === 'string') return self.sanitizeHtml(arg);
        if (Array.isArray(arg)) return self.sanitizeArgs(arg);
        if (typeof arg === 'object' && arg !== null) {
          var result = {};
          for (var k in arg) {
            if (Object.prototype.hasOwnProperty.call(arg, k)) {
              result[k] = typeof arg[k] === 'string' ? self.sanitizeHtml(arg[k]) : (Array.isArray(arg[k]) ? self.sanitizeArgs(arg[k]) : arg[k]);
            }
          }
          return result;
        }
        return arg;
      });
    },
    isSlashMe: function(msg) { return /^\s*\/me\b/i.test(msg || ''); },
    getMeBody: function(msg) {
      var m = msg || '';
      if (!this.isSlashMe(m)) return m;
      var after = m.replace(/^\s*\/me\b/i, '');
      return after.startsWith(' ') ? after.slice(1) : after;
    },
    ON_MESSAGE: function(payload) {
      if (!payload.message || payload.message.args == null) return;
      var args = payload.message.args;
      if (!Array.isArray(args) && typeof args === 'object' && args !== null) {
        var keys = Object.keys(args).filter(function(k) { return /^\d+$/.test(k); }).sort(function(a, b) { return Number(a) - Number(b); });
        args = keys.map(function(k) { return args[k]; });
      }
      if (!Array.isArray(args)) args = [];
      var safeMsgObj = Object.assign({}, payload.message, { args: args });
      safeMsgObj.args = this.sanitizeArgs(safeMsgObj.args);
      this.showWindow = true;
      this.showMessages = true;
      this.messages.push(safeMsgObj);
    },
    ON_CLEAR: function() { this.messages = []; },
    WORLD_ME_DO_BUBBLES: function(payload) {
      if (!this.meDo3DNUIEnabled) {
        this.worldMeDoBubbles = [];
        return;
      }
      this.worldMeDoBubbles = Array.isArray(payload.bubbles) ? payload.bubbles : [];
    },
    ON_SUGGESTION_ADD: function(payload) {
      var suggestion = payload.suggestion;
      if (!Array.isArray(suggestion.params)) {
        if (typeof suggestion.params === 'string' && suggestion.params !== '') suggestion.params = [{ name: suggestion.params }];
        else if (suggestion.params == null) suggestion.params = [];
        else if (typeof suggestion.params === 'object') suggestion.params = Object.values(suggestion.params).map(function(p) { return { name: p }; });
        else suggestion.params = [];
      } else if (suggestion.params.length > 0 && typeof suggestion.params[0] === 'string') {
        suggestion.params = suggestion.params.map(function(p) { return { name: p }; });
      }
      var duplicateSuggestion = this.backingSuggestions.find(function(a) { return a.name == suggestion.name; });
      if (duplicateSuggestion) {
        if (suggestion.help) duplicateSuggestion.help = suggestion.help;
        if (suggestion.params && suggestion.params.length > 0) duplicateSuggestion.params = suggestion.params;
        return;
      }
      this.backingSuggestions.push(suggestion);
    },
    ON_SUGGESTION_REMOVE: function(payload) {
      if (this.removedSuggestions.indexOf(payload.name) <= -1) this.removedSuggestions.push(payload.name);
    },
    ON_TEMPLATE_ADD: function(payload) {
      if (this.templates[payload.template.id]) this.warn('Tried to add duplicate template \'' + payload.template.id + '\'');
      else this.templates[payload.template.id] = payload.template.html;
    },
    ON_UPDATE_THEMES: function(payload) {
      this.removeThemes();
      this.setThemes(payload.themes);
    },
    removeThemes: function() {
      for (var i = 0; i < document.styleSheets.length; i++) {
        var node = document.styleSheets[i].ownerNode;
        if (node.getAttribute('data-theme')) node.parentNode.removeChild(node);
      }
      this.tplBackups.reverse();
      this.tplBackups.forEach(function(item) { item[0].innerText = item[1]; });
      this.tplBackups = [];
      this.msgTplBackups.reverse();
      this.msgTplBackups.forEach(function(item) { this.templates[item[0]] = item[1]; }.bind(this));
      this.msgTplBackups = [];
    },
    setThemes: function(themes) {
      var self = this;
      Object.keys(themes).forEach(function(id) {
        var data = themes[id];
        if (data.style) {
          var style = document.createElement('style');
          style.type = 'text/css';
          style.setAttribute('data-theme', id);
          style.appendChild(document.createTextNode(data.style));
          document.head.appendChild(style);
        }
        if (data.styleSheet) {
          var link = document.createElement('link');
          link.rel = 'stylesheet';
          link.type = 'text/css';
          link.href = data.baseUrl + data.styleSheet;
          link.setAttribute('data-theme', id);
          document.head.appendChild(link);
        }
        if (data.templates) {
          Object.keys(data.templates).forEach(function(tplId) {
            var elem = document.getElementById(tplId);
            if (elem) { self.tplBackups.push([elem, elem.innerText]); elem.innerText = data.templates[tplId]; }
          });
        }
        if (data.script) {
          var script = document.createElement('script');
          script.type = 'text/javascript';
          script.src = data.baseUrl + data.script;
          document.head.appendChild(script);
        }
        if (data.msgTemplates) {
          Object.keys(data.msgTemplates).forEach(function(tplId) {
            self.msgTplBackups.push([tplId, self.templates[tplId]]);
            self.templates[tplId] = data.msgTemplates[tplId];
          });
        }
      });
    },
    warn: function(msg) { this.messages.push({ args: [msg], template: '^3<b>CHAT-WARN</b>: ^0{0}' }); },
    resetShowWindowTimer: function() {
      if (this.showWindowTimer) clearTimeout(this.showWindowTimer);
      var self = this;
      this.showWindowTimer = setTimeout(function() {
        if (!self.showInput) {
          if (self.messages.length > 0) self.storedMessages = self.messages.slice();
          var chatMessages = document.querySelector('.chat-messages');
          if (chatMessages) chatMessages.classList.add('slide-out-left');
          setTimeout(function() {
            self.showMessages = false;
            self.showWindow = false;
            if (chatMessages) chatMessages.classList.remove('slide-out-left');
          }, 400);
        }
      }, (window.CONFIG && window.CONFIG.fadeTimeout) || 8000);
    },
    keyUp: function() {
      var msg = this.message || '';
      var maxLen = this.limitEnabled ? (Number(this.maxLength) || 100) : null;
      if (maxLen) {
        if (this.isSlashMe(msg)) {
          var body = this.getMeBody(msg);
          if (body.length > maxLen) this.message = '/me ' + body.slice(0, maxLen);
        } else {
          if (msg.length > maxLen) this.message = msg.slice(0, maxLen);
        }
      }
      this.resize();
      try { localStorage.setItem('chatDraft', this.message || ''); } catch (err) {}
    },
    keyDown: function(e) {
      if (e.which === 27 && this.showSettings) { e.preventDefault(); this.toggleSettings(); return; }
      if (e.which === 38 || e.which === 40) { e.preventDefault(); this.moveOldMessageIndex(e.which === 38); }
      else if (e.which === 33) { var buf = document.getElementsByClassName('chat-messages')[0]; if (buf) buf.scrollTop = buf.scrollTop - 100; }
      else if (e.which === 34) { var buf = document.getElementsByClassName('chat-messages')[0]; if (buf) buf.scrollTop = buf.scrollTop + 100; }
      else if (e.which === 9) {
        var msg = this.message || '';
        if (msg.charAt(0) !== '/') return;
        var matches = filterMatchingSuggestions(msg, this.suggestions);
        if (matches.length === 1) {
          e.preventDefault();
          this.applySuggestion(matches[0], false);
        }
      }
    },
    moveOldMessageIndex: function(up) {
      if (up && this.oldMessages.length > this.oldMessagesIndex + 1) { this.oldMessagesIndex += 1; this.message = this.oldMessages[this.oldMessagesIndex]; }
      else if (!up && this.oldMessagesIndex - 1 >= 0) { this.oldMessagesIndex -= 1; this.message = this.oldMessages[this.oldMessagesIndex]; }
      else if (!up && this.oldMessagesIndex - 1 === -1) { this.oldMessagesIndex = -1; this.message = ''; }
    },
    applySuggestion: function(suggestion, trailingSpace) {
      if (suggestion && suggestion.name) {
        this.message = suggestion.name + (trailingSpace === false ? '' : ' ');
        var self = this;
        this.$nextTick(function() {
          if (self.$refs.input) {
            self.$refs.input.focus();
            var len = self.$refs.input.value.length;
            self.$refs.input.setSelectionRange(len, len);
            self.resize();
          }
        });
      }
    },
    resize: function() {
      var input = this.$refs.input;
      if (input) { input.style.height = '5px'; input.style.height = (input.scrollHeight + 2) + 'px'; }
    },
    send: function() {
      var msg = this.message || '';
      var maxLen = this.limitEnabled ? (Number(this.maxLength) || 100) : null;
      var toSend = '';
      if (this.isSlashMe(msg)) {
        var bodyFull = this.getMeBody(msg);
        var body = maxLen ? bodyFull.slice(0, maxLen) : bodyFull;
        toSend = body ? ('/me ' + body) : '/me';
      } else toSend = maxLen ? msg.slice(0, maxLen) : msg;
      if (toSend !== '') {
        post('http://jc_chat/chatResult', JSON.stringify({ message: toSend }));
        this.oldMessages.unshift(toSend);
        if (this.oldMessages.length > 50) this.oldMessages = this.oldMessages.slice(0, 50);
        this.oldMessagesIndex = -1;
        this.saveMessageHistory();
        try { localStorage.removeItem('chatDraft'); } catch (err) {}
        this.hideInput();
      } else this.hideInput(true);
    },
    hideInput: function(canceled) {
      if (canceled === undefined) canceled = false;
      var chatInput = document.querySelector('.chat-input');
      if (chatInput) chatInput.style.animation = 'slideOutToLeft var(--anim-fast) var(--ease-in) forwards';
      var self = this;
      setTimeout(function() {
        self.message = '';
        if (canceled) { post('http://jc_chat/chatResult', JSON.stringify({ canceled: true })); try { localStorage.setItem('chatDraft', ''); } catch (err) {} }
        else { try { localStorage.removeItem('chatDraft'); } catch (err) {} }
        self.showInput = false;
        clearInterval(self.focusTimer);
        self.resetShowWindowTimer();
        if (chatInput) chatInput.style.animation = 'slideInFromLeft var(--anim-fast) var(--ease-out) 0s both';
      }, 120);
    },
    toggleSettings: function() {
      var panel = document.querySelector('.settings-panel');
      if (!panel) return;
      if (!this.showSettings) { this.showSettings = true; panel.classList.remove('hide'); panel.classList.add('show'); }
      else {
        panel.classList.remove('show');
        panel.classList.add('hide');
        var self = this;
        setTimeout(function() { self.showSettings = false; }, 400);
      }
    },
    updateChatPosition: function() {
      var self = this;
      var clamp = function(elem, xPct, yPct, opts) {
        opts = opts || {};
        var marginPct = opts.marginPct != null ? opts.marginPct : 1;
        var minX = opts.minX != null ? opts.minX : marginPct;
        var minY = opts.minY != null ? opts.minY : marginPct;
        var hardMaxY = opts.hardMaxY;
        var hardMaxX = opts.hardMaxX;
        var bottomReservePct = opts.bottomReservePct != null ? opts.bottomReservePct : marginPct;
        var vw = window.innerWidth || document.documentElement.clientWidth;
        var vh = window.innerHeight || document.documentElement.clientHeight;
        var ew = elem.offsetWidth || 0;
        var eh = elem.offsetHeight || 0;
        var maxX = Math.max(0, 100 - (ew / vw) * 100 - marginPct);
        var maxY = Math.max(0, 100 - (eh / vh) * 100 - Math.max(marginPct, bottomReservePct));
        var cx = Math.min(Math.max(xPct, minX), maxX);
        var cy = Math.min(Math.max(yPct, minY), maxY);
        if (typeof hardMaxX === 'number') cx = Math.min(cx, hardMaxX);
        if (typeof hardMaxY === 'number') cy = Math.min(cy, hardMaxY);
        return { x: cx, y: cy };
      };
      var chatInput = document.querySelector('.chat-input');
      if (chatInput) {
        var inputShowsSuggestionsBelow = !chatInput.classList.contains('chat-bottom');
        var bottomReservePct = (function() {
          var suggestionsWrap = document.querySelector('.suggestions-wrap');
          var vh = window.innerHeight || document.documentElement.clientHeight;
          var suggestionsPct = 0;
          if (suggestionsWrap && self.showInput) { var rect = suggestionsWrap.getBoundingClientRect(); suggestionsPct = vh ? (rect.height / vh) * 100 : 0; }
          var inputPct = (chatInput && vh) ? (chatInput.offsetHeight / vh) * 100 : 0;
          return inputShowsSuggestionsBelow ? (suggestionsPct + inputPct + 1) : 1;
        })();
        var clampedInput = clamp(chatInput, self.inputPosition.x, self.inputPosition.y, { marginPct: 1, minY: self.baselineInputY, hardMaxY: 65, bottomReservePct: bottomReservePct });
        self.inputPosition = clampedInput;
        chatInput.style.left = clampedInput.x + '%';
        chatInput.style.top = clampedInput.y + '%';
        chatInput.classList.remove('chat-right', 'chat-bottom');
        if (clampedInput.x >= 98.0) chatInput.classList.add('chat-right');
        if (clampedInput.y > 70) chatInput.classList.add('chat-bottom');
        var counter = document.querySelector('.char-counter-floating');
        if (counter) {
          var rect = chatInput.getBoundingClientRect();
          counter.style.left = (rect.right + 10) + 'px';
          counter.style.top = (rect.top + (rect.height / 2) - (counter.offsetHeight / 2)) + 'px';
        }
      }
      var chatWindow = document.querySelector('.chat-window');
      if (chatWindow) {
        if (Math.round(self.inputPosition.x) === 69) chatWindow.classList.add('chat-x-69');
        else chatWindow.classList.remove('chat-x-69');
        var desiredWindowY = self.inputPosition.y - (self.baselineInputY - self.baselineMessagesY);
        var desiredWindowX = self.inputPosition.x - (self.baselineInputX - self.baselineMessagesX);
        chatWindow.classList.remove('right-aligned');
        self.messagesPosition = { x: desiredWindowX, y: desiredWindowY };
        var clampedMsgs = clamp(chatWindow, self.messagesPosition.x, self.messagesPosition.y, { marginPct: 0, minY: self.baselineMessagesY, hardMaxY: 65, bottomReservePct: 1 });
        self.messagesPosition = clampedMsgs;
        chatWindow.style.left = clampedMsgs.x + '%';
        chatWindow.style.top = clampedMsgs.y + '%';
      }
    },
    formatPct: function(v) { return Math.round(Number(v) || 0); },
    updateFontWeight: function() {
      document.documentElement.style.setProperty('--chat-font-weight', this.fontWeight);
      var elements = document.querySelectorAll('.msg, .message, textarea, .suggestions');
      elements.forEach(function(el) { el.style.fontWeight = this.fontWeight; }.bind(this));
    },
    ON_CONFIG: function(payload) {
      try {
        var config = payload.config;
        if (!config) return;
        var enabled = !!(config.limitEnabled);
        var maxLen = Number(config.maxLength);
        if (typeof config.locale === 'string') this.locale = config.locale;
        this.limitEnabled = enabled;
        this.maxLength = Number.isFinite(maxLen) ? maxLen : 100;
        if (!window.CONFIG) window.CONFIG = {};
        if (config.defaultTemplateId) window.CONFIG.defaultTemplateId = config.defaultTemplateId;
        if (config.defaultAltTemplateId) window.CONFIG.defaultAltTemplateId = config.defaultAltTemplateId;
        if (config.defaultPositions && typeof config.defaultPositions === 'object') {
          window.CONFIG.defaultPositions = config.defaultPositions;
          this.inputPosition = config.defaultPositions.input ? Object.assign({}, config.defaultPositions.input) : this.inputPosition;
          this.messagesPosition = config.defaultPositions.messages ? Object.assign({}, config.defaultPositions.messages) : this.messagesPosition;
          this.baselineInputY = (config.defaultPositions.input && config.defaultPositions.input.y) != null ? config.defaultPositions.input.y : 2;
          this.baselineMessagesY = (config.defaultPositions.messages && config.defaultPositions.messages.y) != null ? config.defaultPositions.messages.y : 1.5;
          this.baselineInputX = (config.defaultPositions.input && config.defaultPositions.input.x) != null ? config.defaultPositions.input.x : 0.8;
          this.baselineMessagesX = (config.defaultPositions.messages && config.defaultPositions.messages.x) != null ? config.defaultPositions.messages.x : 0.8;
        }
        if (typeof config.fadeTimeout === 'number') window.CONFIG.fadeTimeout = config.fadeTimeout;
        if (typeof config.suggestionLimit === 'number') window.CONFIG.suggestionLimit = config.suggestionLimit;
        if (config.style && typeof config.style === 'object') { window.CONFIG.style = config.style; this.style = config.style; }
        if (config.templateLabels && typeof config.templateLabels === 'object') window.CONFIG.templateLabels = config.templateLabels;
        if (config.templateClasses && typeof config.templateClasses === 'object') window.CONFIG.templateClasses = config.templateClasses;
        if (typeof config.meDo3DNUI === 'boolean') this.meDo3DNUIEnabled = config.meDo3DNUI;
        if (typeof config.meDo3DDurationMs === 'number' && window.CONFIG) window.CONFIG.meDo3DDurationMs = config.meDo3DDurationMs;
        if (typeof config.meDo3DHeight === 'number' && window.CONFIG) window.CONFIG.meDo3DHeight = config.meDo3DHeight;
      } catch (e) { this.limitEnabled = true; this.maxLength = 100; }
    },
    normalizeBubbleColor: function(color) {
      var def = [200, 200, 200];
      if (!color) return def;
      if (typeof color === 'string' && color.indexOf('#') === 0) {
        var hex = color.replace(/^#/, '');
        if (hex.length === 6) {
          return [
            parseInt(hex.substr(0, 2), 16),
            parseInt(hex.substr(2, 2), 16),
            parseInt(hex.substr(4, 2), 16)
          ];
        }
      }
      if (Array.isArray(color) && color.length >= 3) {
        return [Number(color[0]) || 200, Number(color[1]) || 200, Number(color[2]) || 200];
      }
      if (typeof color === 'object' && color !== null) {
        var r = Number(color[0] != null ? color[0] : color.r) || 200;
        var g = Number(color[1] != null ? color[1] : color.g) || 200;
        var b = Number(color[2] != null ? color[2] : color.b) || 200;
        return [r, g, b];
      }
      return def;
    },
    worldBubbleAccentStyle: function(b) {
      var rgb = this.normalizeBubbleColor(b && b.color);
      return {
        borderColor: 'rgba(' + rgb[0] + ',' + rgb[1] + ',' + rgb[2] + ',0.65)',
        boxShadow: '0 3px 0 rgba(' + rgb[0] + ',' + rgb[1] + ',' + rgb[2] + ',0.85)'
      };
    },
    worldBubbleIconStyle: function(b) {
      var rgb = this.normalizeBubbleColor(b && b.color);
      return {
        background: 'rgba(' + rgb[0] + ',' + rgb[1] + ',' + rgb[2] + ',0.5)',
        border: '1px solid rgba(' + rgb[0] + ',' + rgb[1] + ',' + rgb[2] + ',0.75)'
      };
    },
    worldBubblePositionStyle: function(b) {
      var x = typeof b.x === 'number' ? b.x : 50;
      var y = typeof b.y === 'number' ? b.y : 50;
      return {
        left: x + '%',
        top: y + '%'
      };
    },
    resetSettings: function() {
      this.inputPosition = { x: 1, y: 28 };
      var def = (window.CONFIG && window.CONFIG.defaultPositions) || null;
      var chatWindow = document.querySelector('.chat-window');
      if (chatWindow) {
        var cs = window.getComputedStyle(chatWindow);
        var topStr = cs.top || '';
        var leftStr = cs.left || '';
        var topPctMatch = /([0-9.]+)%/.exec(topStr);
        var leftPctMatch = /([0-9.]+)%/.exec(leftStr);
        if (leftPctMatch) this.messagesPosition.x = parseFloat(leftPctMatch[1]);
        this.baselineMessagesY = topPctMatch ? parseFloat(topPctMatch[1]) : 0.5;
        this.messagesPosition.y = this.baselineMessagesY;
      } else {
        this.messagesPosition = { x: (def ? def.messages.x : this.messagesPosition.x) || 0.8, y: 0.5 };
        this.baselineMessagesY = 0.5;
      }
      this.baselineInputY = 28;
      this.baselineInputX = 1;
      this.fontWeight = 300;
      this.updateChatPosition();
      this.updateFontWeight();
      var settingsPanel = document.querySelector('.settings-panel');
      if (settingsPanel) {
        settingsPanel.style.left = '';
        settingsPanel.style.right = '20px';
        settingsPanel.style.top = '50%';
        settingsPanel.style.transform = 'translateY(-50%)';
      }
      try { localStorage.removeItem('chatSettings'); } catch (e) {}
    },
    saveSettings: function() {
      localStorage.setItem('chatSettings', JSON.stringify({ inputPosition: this.inputPosition, messagesPosition: this.messagesPosition, fontWeight: this.fontWeight }));
      this.toggleSettings();
    },
    loadSettings: function() {
      var savedSettings = null;
      try { savedSettings = localStorage.getItem('chatSettings'); } catch (e) {}
      if (savedSettings) {
        try {
          var settings = JSON.parse(savedSettings);
          if (settings && typeof settings === 'object') {
            if (settings.inputPosition) this.inputPosition = settings.inputPosition;
            if (settings.messagesPosition) this.messagesPosition = settings.messagesPosition;
            if (settings.fontWeight) this.fontWeight = settings.fontWeight;
          }
        } catch (e) {}
      } else {
        var chatInput = document.querySelector('.chat-input');
        if (chatInput) {
          var csIn = window.getComputedStyle(chatInput);
          var topStrIn = csIn.top || '';
          var leftStrIn = csIn.left || '';
          var topPctMatchIn = /([0-9.]+)%/.exec(topStrIn);
          var leftPctMatchIn = /([0-9.]+)%/.exec(leftStrIn);
          if (leftPctMatchIn) this.inputPosition.x = parseFloat(leftPctMatchIn[1]);
          if (topPctMatchIn) this.inputPosition.y = parseFloat(topPctMatchIn[1]);
          if (leftPctMatchIn) this.baselineInputX = parseFloat(leftPctMatchIn[1]);
        } else {
          var def = (window.CONFIG && window.CONFIG.defaultPositions) || null;
          if (def) { this.inputPosition = { x: def.input.x, y: def.input.y }; this.baselineInputX = def.input.x; }
        }
        var def = (window.CONFIG && window.CONFIG.defaultPositions) || null;
        if (def) { this.messagesPosition = { x: def.messages.x, y: def.messages.y }; this.baselineMessagesX = def.messages.x; }
      }
      this.baselineInputY = 28;
      this.baselineInputX = 1;
      if (this.inputPosition && typeof this.inputPosition.y === 'number') {
        if (this.inputPosition.y < 28) this.inputPosition.y = 28;
        if (this.inputPosition.y > 65) this.inputPosition.y = 65;
      }
      var chatWindow = document.querySelector('.chat-window');
      var chatMsgs = document.querySelector('.chat-messages');
      if (chatWindow) {
        var cs = window.getComputedStyle(chatWindow);
        var topStr = cs.top || '';
        var leftStr = cs.left || '';
        var topPctMatch = /([0-9.]+)%/.exec(topStr);
        var leftPctMatch = /([0-9.]+)%/.exec(leftStr);
        if (topPctMatch) this.baselineMessagesY = parseFloat(topPctMatch[1]);
        if (leftPctMatch) this.messagesPosition.x = parseFloat(leftPctMatch[1]);
        if (topPctMatch) this.messagesPosition.y = parseFloat(topPctMatch[1]);
        if (leftPctMatch) this.baselineMessagesX = parseFloat(leftPctMatch[1]);
      }
      if (chatMsgs) {
        var csM = window.getComputedStyle(chatMsgs);
        var topStrM = csM.top || '';
        var topPctMatchM = /([0-9.]+)%/.exec(topStrM);
        if (topPctMatchM) this.baselineMessagesY = parseFloat(topPctMatchM[1]);
      }
      this.updateChatPosition();
      this.updateFontWeight();
    },
    loadMessageHistory: function() {
      try {
        var savedHistory = localStorage.getItem('chatMessageHistory');
        if (savedHistory) {
          var history = JSON.parse(savedHistory);
          if (Array.isArray(history)) this.oldMessages = history.slice(0, 50);
        }
      } catch (e) {}
    },
    saveMessageHistory: function() {
      try { localStorage.setItem('chatMessageHistory', JSON.stringify(this.oldMessages)); } catch (e) {}
    }
  }
};

window.post = function(url, data) {
  var request = new XMLHttpRequest();
  request.open('POST', url, true);
  request.setRequestHeader('Content-Type', 'application/json; charset=UTF-8');
  request.send(data);
};

new Vue({
  el: '#app',
  render: function(h) { return h(APP); }
});

window.emulate = function(type, detail) {
  if (detail == null) detail = {};
  detail.type = type;
  window.dispatchEvent(new CustomEvent('message', { detail: detail }));
};

})();
