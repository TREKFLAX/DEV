return {
  settings = {
    title = 'Paramètres du Chat',
    position = 'Position du Chat',
    chatX = 'Chat X:',
    chatY = 'Chat Y:'
  },
  fontWeight = {
    label = 'Épaisseur de police',
    thin = 'Fin (100)',
    extraLight = 'Extra fin (200)',
    light = 'Léger (300)',
    normal = 'Normal (400)',
    medium = 'Moyen (500)',
    semiBold = 'Semi gras (600)',
    bold = 'Gras (700)',
    extraBold = 'Extra gras (800)',
    black = 'Noir (900)'
  },
  actions = {
    reset = 'Réinitialiser',
    save = 'Enregistrer'
  },
  input = {
    placeholder = 'Écrivez ici...'
  },
  headers = {
    system = 'SYSTÈME',
    ooc = 'OOC',
    me = 'ME',
    ["do"] = 'DO',
    ayuda = 'AIDE',
    id = 'ID',
    twt = 'TWEET',
    anontwt = 'TWEET ANONYME',
    admin = 'CHAT STAFF',
    newcommand = 'Commande test',
    mecanico = 'MÉCANIQUE',
    policia = 'POLICE',
    ems = 'EMS',
    rems = 'RADIO EMS',
    rpol = 'RADIO POLICE',
    dados = 'DÉS'
  },
  commands = {
    me = { help = 'Action à proximité', param = 'message' },
    ["do"] = { help = 'Description d\'environnement', param = 'message' },
    ayuda = { help = 'Demande d\'aide', param = 'message' },
    ooc = { help = 'OOC global', param = 'message' },
    id = { help = 'Message avec ID', param = 'message' },
    pid = { help = 'Demander l\'ID', param = 'message' },
    twt = { help = 'Envoyer un tweet', param = 'message' },
    anontwt = { help = 'Envoyer un tweet anonyme', param = 'message' },
    clear = { help = 'Effacer votre chat local' },
    clearall = { help = 'Effacer le chat pour tous' },
    admin = { help = 'Chat admin', param = 'message' },
    msg = { help = 'Message privé à un joueur' },
    dados = { help = 'Lancer un dé (1-6)' }
  },
  system = {
    title = 'SYSTÈME',
    messages = {
      msg_help = 'Message privé à un joueur',
      msg_invalid_id = 'Usage: /msg ID message',
      msg_self = 'Vous ne pouvez pas vous envoyer un message privé.',
      msg_not_found = 'Joueur introuvable ou non connecté.',
      msg_empty = 'Tapez un message: /msg ID message',
      msg_sent = 'Message envoyé à',
      blocked_profanity = 'Votre message contient des insultes et a été bloqué.',
      blocked_html = 'Votre message a été bloqué pour contenu non autorisé.',
      blocked_html_tags = 'Votre message a été bloqué pour balises ou code non autorisé.',
      perm_denied = 'Vous n\'avez pas la permission d\'utiliser cette commande.',
      perm_denied_clearall = 'Vous n\'avez pas la permission d\'utiliser /clearall.',
      perm_denied_job = 'Vous n\'avez pas le métier requis pour cette commande.',
      el_jugador = 'Le joueur {player} a tenté d\'envoyer du HTML: "{message}"',
      el_jugador_insultos = 'Le joueur {player} a tenté d\'envoyer des insultes: "{message}"',
      unknown_command_prefix = 'La commande n\'existe pas: ',
      dice_result = 'a lancé un dé et a obtenu un {result} 🎲'
    }
  }
}
