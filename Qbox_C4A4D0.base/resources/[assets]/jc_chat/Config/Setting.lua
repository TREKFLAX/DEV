Config = {}

Config.Debug = false

Config.Framework = 'auto' -- 'auto' (automatic detection) | 'qb' or 'esx'

--[[  
Configure your language using the following:
  'es' -> Spanish
  'en' -> English
  'fr' -> French
  'de' -> German
  'it' -> Italian
  'pt' -> Portuguese
]]
Config.Locale = 'en' 

Config.AdminCommand = 'a' -- Admin command configuration

Config.Groups = { -- Groups according to your framework
  esx = { 'superadmin', 'admin', 'owner' },
  qb  = { 'god', 'admin' }
}

Config.MessageLimit = { -- Maximum messages you can put in the message input
  enabled = true,
  maxLength = 100
}

Config.AntiSpam = { -- Anti-spam configuration
  webhook = 'WEBHOOK_HERE',
  enabled = true,
  logToConsole = true,
  exemptAdmins = false
}

Config.TypingIndicator = { -- Typing indicator configuration / This function consume, 
  enabled = false,
  showDistance = 2.0
}

Config.Profanity = { -- Profanity filter configuration
  webhook = 'WEBHOOK_HERE',
  enabled = true,
  blockedWords = {
    'puta','mierda','pendejo','cabrón','gilipollas','imbecil','idiota',
    'negro','marica','perra','concha','hdp','maricon','puto','zorra',
    'cagon','culero','pelotudo','pendeja','tarado','estupido','mongolo',
    'hijo de puta','hijoputa','hijo de perra','hijo de la gran puta',
    'concha de tu madre','conchetumadre','pajero','boludo','forro','chupapija',
    'malparido','carapolla','polla','coño','puta madre','putamadre',
    'hijueputa','hijo e puta','la concha de tu madre','conchetumare',
    'culiao','culiado','qliao','qlo','weon','huevon','mamon','pinga','pene','pito','nabo',
    'choto','carechimba','caremonda','malnacido','desgraciado','cabronazo',
    'putita','putazo','puton','zorrita','gil','baboso','estupida','patan',
    'ptm','lpm','ctm','vrg',

    'fuck','fucking','motherfucker','mf','wtf','shit','bitch','cunt','dick',
    'pussy','asshole','bastard','jerk','retard','retarded','whore','slut',
    'son of a bitch','sonofabitch','s.o.b.','sob','idiot','moron','dumbass',
    'jackass','dickhead','imbecile','stupid', 'faggot','fag','homo','nigger','nigga',
    'cocksucker','prick','cock','penis','twat','wanker','jerkoff','jerk-off',
    'shithead','dickface','fuckface','scumbag'
  },
  exemptAdmins = false
}

Config.DefaultPositions = { -- Default chat positions
  input = { x = 0.8, y = 28 },
  messages = { x = 0.8, y = 1.5 }
}

Config.FadeTimeout = 8000

Config.MeDo3DNUI = false -- Enable/disable the 3D notification UI
Config.MeDo3DDurationMs = 8000 -- Duration of the 3D notification in milliseconds
Config.MeDo3DHeight = 1.08 -- Height of the 3D notification

Config.DefaultMessageColor = { 255, 255, 175 } -- Default color if a command does not have a single color configured
