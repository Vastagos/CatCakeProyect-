extends Control

# Referencias a los nodos
onready var progress_bar = $ProgressBar
onready var label = $Label
onready var btn_eat = $ButtonEat
onready var btn_play = $ButtonPlay
onready var btn_bathe = $ButtonBathe
onready var btn_sleep = $ButtonSleep
onready var popup = $PopupDialog
onready var name_input = $PopupDialog/NameInput
onready var call_input = $PopupDialog/CallInput
onready var confirm_button = $PopupDialog/ConfirmButton

onready var hunger_sprite = $HungerSprite
onready var play_sprite = $PlaySprite
onready var bathe_sprite = $BatheSprite
onready var sleep_sprite = $SleepSprite
onready var smile_sprite = $CatSonrie  # Nuevo nodo de sonrisa

# Energía de la mascota y temporizador
var energy = 100
var pet_name = ""
var player_call = ""
var energy_decrease_interval_initial = 30.0  # Intervalo inicial para disminuir la energía en segundos
var energy_decrease_interval_high_energy = 50.0  # Intervalo para disminuir la energía cuando está alta
var energy_decrease_amount = 10    # Cantidad para disminuir la energía
var time_until_next_decrease = energy_decrease_interval_initial  # Tiempo restante hasta el próximo decremento

func _ready():
	# Conectar las señales de los botones
	btn_eat.connect("pressed", self, "_on_btn_eat_pressed")
	btn_play.connect("pressed", self, "_on_btn_play_pressed")
	btn_bathe.connect("pressed", self, "_on_btn_bathe_pressed")
	btn_sleep.connect("pressed", self, "_on_btn_sleep_pressed")
	confirm_button.connect("pressed", self, "_on_confirm_pressed")
	
	# Mostrar el popup al iniciar
	popup.popup_centered()
	
	# Inicializar la barra de energía
	progress_bar.value = energy
	smile_sprite.visible = true  # Mostrar CatSonrie al inicio
	set_process(true)

func _process(delta):
	# Reducir el temporizador de decremento de energía
	time_until_next_decrease -= delta
	
	# Disminuir la energía en intervalos regulares
	if time_until_next_decrease <= 0:
		if energy > 0:
			energy -= energy_decrease_amount
			energy = max(energy, 0)  # Asegura que la energía no sea menor que 0
			progress_bar.value = energy
			time_until_next_decrease = energy_decrease_interval_initial  # Reiniciar el temporizador con el intervalo inicial
		
		# Verificar la necesidad de atención
		_check_attention()

func _check_attention():
	# Reiniciar la visibilidad de los sprites
	hunger_sprite.visible = false
	play_sprite.visible = false
	bathe_sprite.visible = false
	sleep_sprite.visible = false
	smile_sprite.visible = false
	
	if energy == 0:
		hunger_sprite.visible = true
	elif energy == 10:
		hunger_sprite.visible = true
	elif energy == 20:
		play_sprite.visible = true
	elif energy == 30:
		bathe_sprite.visible = true
	elif energy == 40:
		sleep_sprite.visible = true
	elif energy == 50:
		smile_sprite.visible = true
	elif energy == 60:
		hunger_sprite.visible = true
	elif energy == 70:
		play_sprite.visible = true
	elif energy == 80:
		bathe_sprite.visible = true
	elif energy == 90:
		smile_sprite.visible = true
	elif energy == 100:
		smile_sprite.visible = true
		time_until_next_decrease = energy_decrease_interval_high_energy  # Cambiar el intervalo a 50 segundos

func _on_btn_eat_pressed():
	if energy < 100:
		energy = min(energy + 10, 100)
		progress_bar.value = energy
		label.text = "Has alimentado a tu mascota."
		time_until_next_decrease = energy_decrease_interval_initial  # Reiniciar el temporizador con el intervalo inicial
	_check_attention()

func _on_btn_play_pressed():
	if energy < 100:
		energy = min(energy + 10, 100)
		progress_bar.value = energy
		label.text = "Has jugado con tu mascota."
		time_until_next_decrease = energy_decrease_interval_initial  # Reiniciar el temporizador con el intervalo inicial
	_check_attention()

func _on_btn_bathe_pressed():
	if energy < 100:
		energy = min(energy + 10, 100)
		progress_bar.value = energy
		label.text = "Has bañado a tu mascota."
		time_until_next_decrease = energy_decrease_interval_initial  # Reiniciar el temporizador con el intervalo inicial
	_check_attention()

func _on_btn_sleep_pressed():
	if energy < 100 and is_night_time():
		energy = min(energy + 10, 100)
		progress_bar.value = energy
		label.text = "Has hecho dormir a tu mascota."
		time_until_next_decrease = energy_decrease_interval_initial  # Reiniciar el temporizador con el intervalo inicial
	elif not is_night_time():
		label.text = "Es de día, tu mascota no puede dormir ahora."
	_check_attention()

func _on_confirm_pressed():
	pet_name = name_input.text
	player_call = call_input.text
	popup.hide()
	label.text = "Hola, soy " + pet_name + " y te llamaré " + player_call + "."

func is_night_time() -> bool:
	var current_time = OS.get_datetime().hour
	return current_time >= 20 or current_time < 6  # Suponiendo que la noche es de 20:00 a 06:00
