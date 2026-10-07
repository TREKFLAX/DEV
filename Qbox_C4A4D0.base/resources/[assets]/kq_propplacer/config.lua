Config = {}

-- Enabling this will add additional prints and display of the resource within the pot
Config.debug = false

--
Config.locale = 'en'

Config.sql = {
    driver = 'oxmysql', -- oxmysql or ghmattimysql or mysql
    -- If you're using an older version of oxmysql set this to false
    newOxMysql = true,
}

-- Full UI customization via RGB color values
Config.uiStyling = {
    ['color-background'] = '20, 22, 21',
    ['color-background-light'] = '30, 33, 31',

    ['color-primary-dark'] = '120, 170, 0',
    ['color-primary'] = '178, 243, 0',
    ['color-primary-light'] = '211, 252, 98',
    ['color-primary-lighter'] = '225, 253, 150',

    ['color-secondary'] = '193, 207, 176',
    ['color-secondary-light'] = '226, 245, 203',
    ['color-secondary-dark'] = '111, 117, 103',

    ['color-white'] = '251, 251, 251',
    ['color-black'] = '10, 10, 10',

    -- Border rounding. Higher = rounder panels/buttons
    ['border-radius-sm'] = '0.25rem',
    ['border-radius-md'] = '0.5rem',
    ['border-radius-lg'] = '0.75rem',
    ['border-radius-xl'] = '1.5rem',

    -- Glass backdrop blur strength behind panels
    ['backdrop-blur'] = '16px',
}
