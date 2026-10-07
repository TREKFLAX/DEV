return {
  settings = {
    title = 'Chat Settings',
    position = 'Chat Position',
    chatX = 'Chat X:',
    chatY = 'Chat Y:'
  },
  fontWeight = {
    label = 'Font Weight',
    thin = 'Thin (100)',
    extraLight = 'Extra Light (200)',
    light = 'Light (300)',
    normal = 'Normal (400)',
    medium = 'Medium (500)',
    semiBold = 'Semi Bold (600)',
    bold = 'Bold (700)',
    extraBold = 'Extra Bold (800)',
    black = 'Black (900)'
  },
  actions = {
    reset = 'Reset',
    save = 'Save'
  },
  input = {
    placeholder = 'Type here...'
  },
  headers = {
    system = 'SYSTEM',
    ooc = 'OOC',
    me = 'ME',
    ["do"] = 'DO',
    ayuda = 'HELP',
    id = 'ID',
    twt = 'TWEET',
    anontwt = 'ANONYMOUS TWEET',
    admin = 'STAFF CHAT',
    newcommand = 'Test command',
    mecanico = 'MECHANIC',
    policia = 'POLICE',
    ems = 'EMS',
    rems = 'EMS RADIO',
    rpol = 'POLICE RADIO',
    example = 'EXAMPLE',
    dados = 'DICE'
  },
  commands = {
    me = { help = 'Nearby action', param = 'message' },
    ["do"] = { help = 'Environment description', param = 'message' },
    ayuda = { help = 'Help request', param = 'message' },
    ooc = { help = 'OOC global', param = 'message' },
    id = { help = 'Message with ID', param = 'message' },
    pid = { help = 'Ask ID', param = 'message' },
    twt = { help = 'Send tweet', param = 'message' },
    anontwt = { help = 'Send anonymous tweet', param = 'message' },
    clear = { help = 'Clear your local chat' },
    clearall = { help = 'Clear chat for all' },
    admin = { help = 'Admin chat', param = 'message' },
    msg = { help = 'Private message to a player' },
    example = { help = 'Example command with locales', param = 'message' },
    dados = { help = 'Roll a dice (1-6)' }
  },
  system = {
    title = 'SYSTEM',
    messages = {
      msg_help = 'Private message to a player',
      msg_invalid_id = 'Usage: /msg ID message',
      msg_self = 'You cannot send a private message to yourself.',
      msg_not_found = 'Player not found or not connected.',
      msg_empty = 'Type a message: /msg ID message',
      msg_sent = 'Message sent to',
      blocked_profanity = 'Your message contains profanity and was blocked.',
      blocked_html = 'Your message was blocked for containing disallowed code.',
      blocked_html_tags = 'Your message was blocked for containing tags or disallowed code.',
      perm_denied = 'You do not have permission to use this command.',
      perm_denied_clearall = 'You do not have permission to use /clearall.',
      perm_denied_job = 'You do not have the required job to use this command.',
      el_jugador = 'Player {player} tried to send HTML: "{message}"',
      el_jugador_insultos = 'Player {player} tried to send profanity: "{message}"',
      unknown_command_prefix = 'Command does not exist: ',
      dice_result = 'rolled a dice and got a {result} 🎲'
    }
  }
}