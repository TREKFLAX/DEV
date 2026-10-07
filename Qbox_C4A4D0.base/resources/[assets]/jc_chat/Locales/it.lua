return {
  settings = {
    title = 'Impostazioni Chat',
    position = 'Posizione Chat',
    chatX = 'Chat X:',
    chatY = 'Chat Y:'
  },
  fontWeight = {
    label = 'Spessore carattere',
    thin = 'Sottile (100)',
    extraLight = 'Extra sottile (200)',
    light = 'Leggero (300)',
    normal = 'Normale (400)',
    medium = 'Medio (500)',
    semiBold = 'Semi grassetto (600)',
    bold = 'Grassetto (700)',
    extraBold = 'Extra grassetto (800)',
    black = 'Nero (900)'
  },
  actions = {
    reset = 'Reimposta',
    save = 'Salva'
  },
  input = {
    placeholder = 'Scrivi qui...'
  },
  headers = {
    system = 'SISTEMA',
    ooc = 'OOC',
    me = 'ME',
    ["do"] = 'DO',
    ayuda = 'AIUTO',
    id = 'ID',
    twt = 'TWEET',
    anontwt = 'TWEET ANONIMO',
    admin = 'CHAT STAFF',
    newcommand = 'Comando di test',
    mecanico = 'MECCANICO',
    policia = 'POLIZIA',
    ems = 'EMS',
    rems = 'RADIO EMS',
    rpol = 'RADIO POLIZIA',
    dados = 'DADI'
  },
  commands = {
    me = { help = 'Azione nelle vicinanze', param = 'messaggio' },
    ["do"] = { help = 'Descrizione ambiente', param = 'messaggio' },
    ayuda = { help = 'Richiesta di aiuto', param = 'messaggio' },
    ooc = { help = 'OOC globale', param = 'messaggio' },
    id = { help = 'Messaggio con ID', param = 'messaggio' },
    pid = { help = 'Chiedi ID', param = 'messaggio' },
    twt = { help = 'Invia tweet', param = 'messaggio' },
    anontwt = { help = 'Invia tweet anonimo', param = 'messaggio' },
    clear = { help = 'Svuota la chat locale' },
    clearall = { help = 'Svuota chat per tutti' },
    admin = { help = 'Chat admin', param = 'messaggio' },
    msg = { help = 'Messaggio privato a un giocatore' },
    dados = { help = 'Lancia un dado (1-6)' }
  },
  system = {
    title = 'SISTEMA',
    messages = {
      msg_help = 'Messaggio privato a un giocatore',
      msg_invalid_id = 'Uso: /msg ID messaggio',
      msg_self = 'Non puoi inviarti un messaggio privato.',
      msg_not_found = 'Giocatore non trovato o non connesso.',
      msg_empty = 'Scrivi un messaggio: /msg ID messaggio',
      msg_sent = 'Messaggio inviato a',
      blocked_profanity = 'Il tuo messaggio contiene insulti ed è stato bloccato.',
      blocked_html = 'Il tuo messaggio è stato bloccato per codice non consentito.',
      blocked_html_tags = 'Il tuo messaggio è stato bloccato per tag o codice non consentito.',
      perm_denied = 'Non hai il permesso di usare questo comando.',
      perm_denied_clearall = 'Non hai il permesso di usare /clearall.',
      perm_denied_job = 'Non hai il lavoro richiesto per questo comando.',
      el_jugador = 'Il giocatore {player} ha tentato di inviare HTML: "{message}"',
      el_jugador_insultos = 'Il giocatore {player} ha tentato di inviare insulti: "{message}"',
      unknown_command_prefix = 'Il comando non esiste: ',
      dice_result = 'ha lanciato un dado e ha ottenuto un {result} 🎲'
    }
  }
}
