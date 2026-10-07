return {
  settings = {
    title = 'Configurações do Chat',
    position = 'Posição do Chat',
    chatX = 'Chat X:',
    chatY = 'Chat Y:'
  },
  fontWeight = {
    label = 'Peso da Fonte',
    thin = 'Fino (100)',
    extraLight = 'Extra fino (200)',
    light = 'Leve (300)',
    normal = 'Normal (400)',
    medium = 'Médio (500)',
    semiBold = 'Semi negrito (600)',
    bold = 'Negrito (700)',
    extraBold = 'Extra negrito (800)',
    black = 'Preto (900)'
  },
  actions = {
    reset = 'Repor',
    save = 'Guardar'
  },
  input = {
    placeholder = 'Escreve aqui...'
  },
  headers = {
    system = 'SISTEMA',
    ooc = 'OOC',
    me = 'ME',
    ["do"] = 'DO',
    ayuda = 'AJUDA',
    id = 'ID',
    twt = 'TWEET',
    anontwt = 'TWEET ANÓNIMO',
    admin = 'CHAT STAFF',
    newcommand = 'Comando de teste',
    mecanico = 'MECÂNICO',
    policia = 'POLÍCIA',
    ems = 'EMS',
    rems = 'RÁDIO EMS',
    rpol = 'RÁDIO POLÍCIA',
    dados = 'DADOS'
  },
  commands = {
    me = { help = 'Ação próxima', param = 'mensagem' },
    ["do"] = { help = 'Descrição do ambiente', param = 'mensagem' },
    ayuda = { help = 'Pedido de ajuda', param = 'mensagem' },
    ooc = { help = 'OOC global', param = 'mensagem' },
    id = { help = 'Mensagem com ID', param = 'mensagem' },
    pid = { help = 'Pedir ID', param = 'mensagem' },
    twt = { help = 'Enviar tweet', param = 'mensagem' },
    anontwt = { help = 'Enviar tweet anónimo', param = 'mensagem' },
    clear = { help = 'Limpar o teu chat local' },
    clearall = { help = 'Limpar chat para todos' },
    admin = { help = 'Chat de administradores', param = 'mensagem' },
    msg = { help = 'Mensagem privada a um jogador' },
    dados = { help = 'Atirar um dado (1-6)' }
  },
  system = {
    title = 'SISTEMA',
    messages = {
      msg_help = 'Mensagem privada a um jogador',
      msg_invalid_id = 'Uso: /msg ID mensagem',
      msg_self = 'Não podes enviar uma mensagem privada a ti mesmo.',
      msg_not_found = 'Jogador não encontrado ou não ligado.',
      msg_empty = 'Escreve uma mensagem: /msg ID mensagem',
      msg_sent = 'Mensagem enviada para',
      blocked_profanity = 'A tua mensagem contém insultos e foi bloqueada.',
      blocked_html = 'A tua mensagem foi bloqueada por conter código não permitido.',
      blocked_html_tags = 'A tua mensagem foi bloqueada por conter etiquetas ou código não permitido.',
      perm_denied = 'Não tens permissão para usar este comando.',
      perm_denied_clearall = 'Não tens permissão para usar /clearall.',
      perm_denied_job = 'Não tens o emprego necessário para este comando.',
      el_jugador = 'O jogador {player} tentou enviar HTML: "{message}"',
      el_jugador_insultos = 'O jogador {player} tentou enviar insultos: "{message}"',
      unknown_command_prefix = 'O comando não existe: ',
      dice_result = 'atirou um dado e sacou um {result} 🎲'
    }
  }
}
