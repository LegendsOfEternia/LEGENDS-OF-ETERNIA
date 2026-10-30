extends Control

const BG := Color("#101827")
const PANEL := Color("#1b2940")
const GOLD := Color("#e7bd69")
const TEXT_COLOR := Color("#f4efe3")
const MUTED := Color("#b7c3d5")

var language := "hu"
var selected_class := "knight"
var title_label: Label
var subtitle_label: Label
var status_label: Label
var choose_label: Label
var class_buttons: Dictionary = {}

func _ready() -> void:
    _build_interface()

func _build_interface() -> void:
    var background := ColorRect.new()
    background.color = BG
    background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    add_child(background)

    var root := VBoxContainer.new()
    root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    root.add_theme_constant_override("separation", 16)
    root.add_theme_constant_override("margin_left", 40)
    root.add_theme_constant_override("margin_right", 40)
    root.add_theme_constant_override("margin_top", 24)
    root.add_theme_constant_override("margin_bottom", 24)
    add_child(root)

    var top := HBoxContainer.new()
    top.alignment = BoxContainer.ALIGNMENT_END
    root.add_child(top)

    var lang_button := Button.new()
    lang_button.text = "EN / HU"
    lang_button.custom_minimum_size = Vector2(110, 42)
    lang_button.pressed.connect(_toggle_language)
    top.add_child(lang_button)

    title_label = Label.new()
    title_label.text = "LEGENDS OF ETERNIA"
    title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    title_label.add_theme_font_size_override("font_size", 42)
    title_label.add_theme_color_override("font_color", GOLD)
    root.add_child(title_label)

    subtitle_label = Label.new()
    subtitle_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    subtitle_label.add_theme_font_size_override("font_size", 18)
    subtitle_label.add_theme_color_override("font_color", TEXT_COLOR)
    root.add_child(subtitle_label)

    var spacer := Control.new()
    spacer.size_flags_vertical = Control.SIZE_EXPAND_FILL
    root.add_child(spacer)

    var panel := PanelContainer.new()
    panel.custom_minimum_size = Vector2(0, 250)
    var panel_style := StyleBoxFlat.new()
    panel_style.bg_color = PANEL
    panel_style.border_color = Color("#425775")
    panel_style.set_border_width_all(2)
    panel_style.set_corner_radius_all(14)
    panel_style.content_margin_left = 24
    panel_style.content_margin_right = 24
    panel_style.content_margin_top = 20
    panel_style.content_margin_bottom = 20
    panel.add_theme_stylebox_override("panel", panel_style)
    root.add_child(panel)

    var panel_content := VBoxContainer.new()
    panel_content.add_theme_constant_override("separation", 18)
    panel.add_child(panel_content)

    choose_label = Label.new()
    choose_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    choose_label.add_theme_font_size_override("font_size", 24)
    choose_label.add_theme_color_override("font_color", TEXT_COLOR)
    panel_content.add_child(choose_label)

    var choices := HBoxContainer.new()
    choices.alignment = BoxContainer.ALIGNMENT_CENTER
    choices.add_theme_constant_override("separation", 14)
    panel_content.add_child(choices)

    _add_class_button(choices, "knight")
    _add_class_button(choices, "mage")
    _add_class_button(choices, "archer")

    var spacer_bottom := Control.new()
    spacer_bottom.size_flags_vertical = Control.SIZE_EXPAND_FILL
    root.add_child(spacer_bottom)

    status_label = Label.new()
    status_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    status_label.add_theme_color_override("font_color", MUTED)
    root.add_child(status_label)

    var footer := Label.new()
    footer.text = "EARLY DEVELOPMENT BUILD  •  NOT AN ONLINE GAME"
    footer.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    footer.add_theme_color_override("font_color", Color("#78899f"))
    footer.add_theme_font_size_override("font_size", 12)
    root.add_child(footer)

    _refresh_text()

func _add_class_button(parent: HBoxContainer, class_id: String) -> void:
    var button := Button.new()
    button.custom_minimum_size = Vector2(210, 105)
    button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    button.pressed.connect(_select_class.bind(class_id))
    parent.add_child(button)
    class_buttons[class_id] = button

func _refresh_text() -> void:
    var hu := language == "hu"
    subtitle_label.text = "Egy új fantasy világ legendája kezdődik." if hu else "The legend of a new fantasy world begins."
    choose_label.text = "Válassz kasztot" if hu else "Choose your class"

    var names := {
        "knight": "Lovag" if hu else "Knight",
        "mage": "Mágus" if hu else "Mage",
        "archer": "Íjász" if hu else "Archer"
    }
    var descriptions := {
        "knight": "Védelem és közelharc" if hu else "Defense and melee",
        "mage": "Mágia és távolsági sebzés" if hu else "Magic and ranged damage",
        "archer": "Pontosság és gyorsaság" if hu else "Precision and agility"
    }

    for class_id in class_buttons:
        var button: Button = class_buttons[class_id]
        button.text = names[class_id] + "\n" + descriptions[class_id]
        button.add_theme_font_size_override("font_size", 19)
        button.add_theme_color_override("font_color", GOLD if selected_class == class_id else TEXT_COLOR)

    status_label.text = ("Kiválasztott kaszt: " if hu else "Selected class: ") + names[selected_class]

func _select_class(class_id: String) -> void:
    selected_class = class_id
    _refresh_text()

func _toggle_language() -> void:
    language = "en" if language == "hu" else "hu"
    _refresh_text()
