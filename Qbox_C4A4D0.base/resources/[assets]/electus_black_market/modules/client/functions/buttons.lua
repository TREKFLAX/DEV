-- Source: https://gist.github.com/DemmyDemon/69d53b78b005a7c1a6fdb9036e401f4c & https://gist.github.com/lfshr/f58011a315b61f9d0af80d4484cbc49e
local buttons = {
    ["b-1"] = "Unknown Key",

    -- Controller Bindings
    b_4 = "D-Pad Up",
    b_5 = "D-Pad Down",
    b_6 = "D-Pad Left",
    b_7 = "D-Pad Right",
    b_13 = "Left Stick Down",
    b_12 = "Left Stick Up",
    b_14 = "Left Stick Left",
    b_15 = "Left Stick Right",
    b_16 = "Left Stick Click",
    b_18 = "Left Stick Up/Down",
    b_19 = "Left Stick Left/Right",
    b_21 = "Right Stick Up",
    b_22 = "Right Stick Down",
    b_23 = "Right Stick Left",
    b_24 = "Right Stick Right",
    b_25 = "Right Stick Click",
    b_27 = "Right Stick Up/Down",
    b_28 = "Right Stick Left/Right",
    b_30 = "A Button",
    b_31 = "B Button",
    b_32 = "X Button",
    b_33 = "Y Button",
    b_34 = "Left Bumper",
    b_35 = "Left Trigger",
    b_36 = "Right Bumper",
    b_37 = "Right Trigger",
    b_38 = "Menu Button",
    b_39 = "View Button",

    -- Mouse Bindings
    b_100 = "Mouse 1",
    b_101 = "Mouse 2",
    b_102 = "Mouse 3",
    b_103 = "Mouse 4",
    b_104 = "Mouse 5",
    b_105 = "Mouse 6",
    b_106 = "Mouse 7",
    b_107 = "Mouse 8",
    b_108 = "Mouse Left",
    b_109 = "Mouse Right",
    b_110 = "Mouse Up",
    b_111 = "Mouse Down",
    b_112 = "Mouse Left/Right",
    b_113 = "Mouse Up/Down",
    b_114 = "Mouse Movement",
    b_115 = "Scroll Up",
    b_116 = "Scroll Down",
    b_117 = "Mouse Wheel",

    -- Numpad Keys
    b_130 = "Numpad -",
    b_131 = "Numpad +",
    b_132 = "Numpad .",
    b_133 = "Numpad /",
    b_134 = "Numpad *",
    b_135 = "Numpad Enter",
    b_136 = "Numpad 0",
    b_137 = "Numpad 1",
    b_138 = "Numpad 2",
    b_139 = "Numpad 3",
    b_140 = "Numpad 4",
    b_141 = "Numpad 5",
    b_142 = "Numpad 6",
    b_143 = "Numpad 7",
    b_144 = "Numpad 8",
    b_145 = "Numpad 9",
    b_146 = "Numpad =",
    b_147 = "Numpad ,",
    b_148 = "Numpad /",
    b_149 = "Numpad *",

    -- Function & Navigation Keys
    b_150 = "Enter",
    b_151 = "Grave Accent (`/~)",
    b_170 = "F1",
    b_171 = "F2",
    b_172 = "F3",
    b_173 = "F4",
    b_174 = "F5",
    b_175 = "F6",
    b_176 = "F7",
    b_177 = "F8",
    b_178 = "F9",
    b_179 = "F10",
    b_180 = "F11",
    b_181 = "F12",
    b_182 = "F13",
    b_183 = "F14",
    b_184 = "F15",
    b_185 = "F16",
    b_186 = "F17",
    b_187 = "F18",
    b_188 = "F19",
    b_189 = "F20",
    b_190 = "F21",
    b_191 = "F22",
    b_192 = "F23",
    b_193 = "F24",
    b_194 = "Up Arrow",
    b_195 = "Down Arrow",
    b_196 = "Left Arrow",
    b_197 = "Right Arrow",
    b_198 = "Delete",
    b_199 = "Escape",
    b_200 = "Insert",
    b_201 = "End",
    b_202 = "Delete",
    b_203 = "Escape",
    b_204 = "End",
    b_205 = "Delete",
    b_206 = "Insert",
    b_207 = "End",
    b_208 = "Delete",
    b_209 = "End",
    b_210 = "Delete",
    b_211 = "Insert",
    b_212 = "End",
    b_213 = "Delete",

    -- Misc / Unidentified
    b_214 = "Insert",
    b_215 = "End",
    b_216 = "Diaeresis (¨)",
    b_217 = "Grave Accent (`/~)",
    b_995 = "Unknown Key",
    b_998 = "+",

    -- Main Keyboard Keys
    b_1000 = "Left Shift",
    b_1001 = "Right Shift",
    b_1002 = "Tab",
    b_1003 = "Enter",
    b_1004 = "Backspace",
    b_1005 = "Print Screen",
    b_1006 = "Scroll Lock",
    b_1007 = "Pause",
    b_1008 = "Home",
    b_1009 = "Page Up",
    b_1010 = "Page Down",
    b_1011 = "Num Lock",
    b_1012 = "Caps Lock",
    b_1013 = "Left Ctrl",
    b_1014 = "Right Ctrl",
    b_1015 = "Left Alt",
    b_1016 = "Right Alt",
    b_1017 = "Menu Key",
    b_1018 = "Left Win",
    b_1019 = "Right Win",

    -- Mapped from various European keyboard layouts
    b_1020 = "Print Screen",
    b_1021 = "Scroll Lock",
    b_1022 = "Home",
    b_1023 = "Page Up",
    b_1024 = "Page Down",
    b_1025 = "Num Lock",
    b_1026 = "Caps Lock",
    b_1027 = "Left Ctrl",
    b_1028 = "Right Ctrl",
    b_1029 = "Print Screen",
    b_1030 = "Scroll Lock",
    b_1031 = "Home",
    b_1032 = "Page Up",
    b_1033 = "Page Down",
    b_1034 = "Num Lock",
    b_1035 = "Caps Lock",
    b_1036 = "Left Ctrl",
    b_1037 = "Right Ctrl",
    b_1038 = "Left Shift",
    b_1039 = "Right Shift",
    b_1040 = "Enter",
    b_1041 = "Print Screen",
    b_1042 = "Scroll Lock",
    b_1043 = "Pause",
    b_1044 = "Home",
    b_1045 = "Page Up",
    b_1046 = "Page Down",
    b_1047 = "Num Lock",
    b_1048 = "Caps Lock",
    b_1049 = "Left Ctrl",
    b_1050 = "Right Ctrl",
    b_1051 = "AltGr",
    b_1052 = "Print Screen",
    b_1053 = "Scroll Lock",
    b_1054 = "Pause",
    b_1055 = "Home",
    b_1056 = "Page Up",
    b_1057 = "Page Down",
    b_1058 = "Num Lock",
    b_1059 = "Caps Lock",
    b_1060 = "Left Ctrl",
    b_1061 = "Right Ctrl",
    b_1062 = "Menu Key",
    b_1070 = "Caps Lock",
    b_1071 = "Menu Key",
    b_1072 = "Left Shift",
    b_1073 = "Right Shift",
    b_1074 = "Alt",
    b_1075 = "Right Alt",
    b_1076 = "Left Shift",
    b_1077 = "Right Shift",
    b_2000 = "Space",
}

---@param instructionalButton string
---@return string?
local function GetButtonFromInstructional(instructionalButton)
    local instructionalType = instructionalButton:sub(1, 2)

    if buttons[instructionalButton] then
        return buttons[instructionalButton]
    end

    if instructionalType == "t_" then
        local button = instructionalButton:gsub("t_", "")

        return button
    end
end

---@param control number
---@param padIndex? number
---@return string
function GetControlKey(control, padIndex)
    local instructionalButton = GetControlInstructionalButton(padIndex or 0, control, true)

    if instructionalButton:find("%%") then
        local alternatives = {}

        for alternative in instructionalButton:gmatch("([^%%]+)") do
            local button = GetButtonFromInstructional(alternative)

            if button then
                alternatives[#alternatives+1] = button
            end
        end

        if #alternatives > 0 then
            return table.concat(alternatives, "/")
        end
    end

    local button = GetButtonFromInstructional(instructionalButton)

    if button then
        return button
    end

    infoprint("warning", "Unrecognized control key:", control, "Instructional Button:", instructionalButton)

    return "Unknown Key"
end
