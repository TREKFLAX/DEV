return {
  settings = {
    title = 'Configuración del Chat',
    position = 'Posición del Chat',
    chatX = 'Chat X:',
    chatY = 'Chat Y:'
  },
  fontWeight = {
    label = 'Peso de Fuente',
    thin = 'Fino (100)',
    extraLight = 'Extra Fino (200)',
    light = 'Ligero (300)',
    normal = 'Normal (400)',
    medium = 'Medio (500)',
    semiBold = 'Semi Negrita (600)',
    bold = 'Negrita (700)',
    extraBold = 'Extra Negrita (800)',
    black = 'Negra (900)'
  },
  actions = {
    reset = 'Restablecer',
    save = 'Guardar'
  },
  input = {
    placeholder = 'Escribe aqui...'
  },
  headers = {
    system = 'SISTEMA',
    ooc = 'OOC',
    me = 'ME',
    ["do"] = 'DO',
    ayuda = 'AYUDA',
    id = 'ID',
    twt = 'TWEET',
    anontwt = 'TWEET ANÓNIMO',
    admin = 'CHAT STAFF',
    newcommand = 'Comando de prueba',
    mecanico = 'MECÁNICO',
    policia = 'POLICÍA',
    ems = 'EMS',
    rems = 'RADIO EMS',
    rpol = 'RADIO POLICÍA',
    example = 'EJEMPLO',
    dados = 'DADOS'
  },
  commands = {
    me = { help = 'Acción cercana', param = 'mensaje' },
    ["do"] = { help = 'Descripción de entorno', param = 'mensaje' },
    ayuda = { help = 'Solicitud de ayuda', param = 'mensaje' },
    ooc = { help = 'OOC global', param = 'mensaje' },
    id = { help = 'Mensaje con ID', param = 'mensaje' },
    pid = { help = 'Solicitar ID', param = 'mensaje' },
    twt = { help = 'Enviar tweet', param = 'mensaje' },
    anontwt = { help = 'Enviar tweet anónimo', param = 'mensaje' },
    clear = { help = 'Limpia tu chat local' },
    clearall = { help = 'Limpia el chat de todos' },
    admin = { help = 'Chat de administradores', param = 'mensaje' },
    msg = { help = 'Mensaje privado a un jugador' },
    example = { help = 'Comando de ejemplo con locales', param = 'mensaje' },
    dados = { help = 'Tirar un dado (1-6)' }
  },
  system = {
    title = 'SISTEMA',
    messages = {
      msg_help = 'Mensaje privado a un jugador',
      msg_invalid_id = 'Usa: /msg ID mensaje',
      msg_self = 'No puedes enviarte un mensaje privado a ti mismo.',
      msg_not_found = 'Jugador no encontrado o no conectado.',
      msg_empty = 'Escribe un mensaje: /msg ID mensaje',
      msg_sent = 'Mensaje enviado a',
      blocked_profanity = 'Tu mensaje contiene insultos y ha sido bloqueado.',
      blocked_html = 'Tu mensaje ha sido bloqueado por contener código no permitido.',
      blocked_html_tags = 'Tu mensaje ha sido bloqueado por contener etiquetas o código no permitido.',
      perm_denied = 'No tienes permiso para usar este comando.',
      perm_denied_job = 'No tienes el job requerido para usar este comando.',
      el_jugador = 'El jugador {player} intentó enviar HTML: "{message}"',
      el_jugador_insultos = 'El jugador {player} intentó enviar insultos: "{message}"',
      perm_denied_clearall = 'No tienes permiso para usar /clearall.',
      unknown_command_prefix = 'El comando no existe: ',
      dice_result = 'ha tirado un dado y ha sacado un {result} 🎲'
    }
  }
}