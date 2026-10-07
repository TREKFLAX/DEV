return {
  settings = {
    title = 'Chat-Einstellungen',
    position = 'Chat-Position',
    chatX = 'Chat X:',
    chatY = 'Chat Y:'
  },
  fontWeight = {
    label = 'Schriftstärke',
    thin = 'Dünn (100)',
    extraLight = 'Extra dünn (200)',
    light = 'Leicht (300)',
    normal = 'Normal (400)',
    medium = 'Mittel (500)',
    semiBold = 'Halbfett (600)',
    bold = 'Fett (700)',
    extraBold = 'Extra fett (800)',
    black = 'Schwarz (900)'
  },
  actions = {
    reset = 'Zurücksetzen',
    save = 'Speichern'
  },
  input = {
    placeholder = 'Hier tippen...'
  },
  headers = {
    system = 'SYSTEM',
    ooc = 'OOC',
    me = 'ME',
    ["do"] = 'DO',
    ayuda = 'HILFE',
    id = 'ID',
    twt = 'TWEET',
    anontwt = 'ANONYMER TWEET',
    admin = 'STAFF-CHAT',
    newcommand = 'Testbefehl',
    mecanico = 'MECHANIKER',
    policia = 'POLIZEI',
    ems = 'EMS',
    rems = 'EMS-FUNK',
    rpol = 'POLIZEI-FUNK',
    dados = 'WÜRFEL'
  },
  commands = {
    me = { help = 'Aktion in der Nähe', param = 'nachricht' },
    ["do"] = { help = 'Umgebungsbeschreibung', param = 'nachricht' },
    ayuda = { help = 'Hilfeanfrage', param = 'nachricht' },
    ooc = { help = 'OOC global', param = 'nachricht' },
    id = { help = 'Nachricht mit ID', param = 'nachricht' },
    pid = { help = 'ID anfragen', param = 'nachricht' },
    twt = { help = 'Tweet senden', param = 'nachricht' },
    anontwt = { help = 'Anonymen Tweet senden', param = 'nachricht' },
    clear = { help = 'Lokalen Chat leeren' },
    clearall = { help = 'Chat für alle leeren' },
    admin = { help = 'Admin-Chat', param = 'nachricht' },
    msg = { help = 'Private Nachricht an einen Spieler' },
    dados = { help = 'Einen Würfel werfen (1-6)' }
  },
  system = {
    title = 'SYSTEM',
    messages = {
      msg_help = 'Private Nachricht an einen Spieler',
      msg_invalid_id = 'Verwendung: /msg ID nachricht',
      msg_self = 'Du kannst dir keine private Nachricht senden.',
      msg_not_found = 'Spieler nicht gefunden oder nicht verbunden.',
      msg_empty = 'Nachricht eingeben: /msg ID nachricht',
      msg_sent = 'Nachricht gesendet an',
      blocked_profanity = 'Deine Nachricht enthält Beleidigungen und wurde blockiert.',
      blocked_html = 'Deine Nachricht wurde wegen nicht erlaubtem Code blockiert.',
      blocked_html_tags = 'Deine Nachricht wurde wegen Tags oder nicht erlaubtem Code blockiert.',
      perm_denied = 'Du hast keine Berechtigung für diesen Befehl.',
      perm_denied_clearall = 'Du hast keine Berechtigung für /clearall.',
      perm_denied_job = 'Du hast nicht den erforderlichen Job für diesen Befehl.',
      el_jugador = 'Spieler {player} versuchte HTML zu senden: "{message}"',
      el_jugador_insultos = 'Spieler {player} versuchte Beleidigungen zu senden: "{message}"',
      unknown_command_prefix = 'Befehl existiert nicht: ',
      dice_result = 'hat einen Würfel geworfen und eine {result} 🎲 erhalten'
    }
  }
}
