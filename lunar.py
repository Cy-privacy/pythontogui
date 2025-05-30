import json
import os
import sys
from PyQt6.QtWidgets import (QApplication, QMainWindow, QWidget, QVBoxLayout, 
                            QPushButton, QLabel, QStackedWidget, QLineEdit)
from PyQt6.QtCore import Qt, QTimer, QPropertyAnimation, QEasingCurve
from PyQt6.QtGui import QFont, QIcon
from qt_material import apply_stylesheet
from pynput import keyboard
from termcolor import colored
import torch

class LunarGUI(QMainWindow):
    def __init__(self):
        super().__init__()
        self.setWindowTitle("Lunar AI Aimbot")
        self.setFixedSize(900, 600)
        
        # Create stacked widget for multiple pages
        self.stacked_widget = QStackedWidget()
        self.setCentralWidget(self.stacked_widget)
        
        # Create pages
        self.main_page = self.create_main_page()
        self.settings_page = self.create_settings_page()
        
        # Add pages to stacked widget
        self.stacked_widget.addWidget(self.main_page)
        self.stacked_widget.addWidget(self.settings_page)
        
        # Initialize animations
        self.setup_animations()
        
        # Apply modern style
        apply_stylesheet(self, theme='dark_teal.xml')
        
        # Check CUDA status
        self.check_cuda_status()
        
    def check_cuda_status(self):
        cuda_available = torch.cuda.is_available()
        if cuda_available:
            cuda_device = torch.cuda.get_device_name(0)
            cuda_version = torch.version.cuda
            self.cuda_status = QLabel(f"CUDA Status: Enabled\nDevice: {cuda_device}\nCUDA Version: {cuda_version}")
        else:
            self.cuda_status = QLabel("CUDA Status: Disabled - GPU acceleration unavailable")
        self.cuda_status.setAlignment(Qt.AlignmentFlag.AlignCenter)
        self.cuda_status.setStyleSheet("color: #00ff00;" if cuda_available else "color: #ff0000;")
        
    def create_main_page(self):
        page = QWidget()
        layout = QVBoxLayout()
        
        # Title
        title = QLabel("LUNAR AI AIMBOT")
        title.setAlignment(Qt.AlignmentFlag.AlignCenter)
        title.setFont(QFont('Arial', 24, QFont.Weight.Bold))
        layout.addWidget(title)
        
        # CUDA Status
        layout.addWidget(self.cuda_status)
        
        # Status indicators
        self.aimbot_status = QLabel("Aimbot Status: Inactive")
        self.aimbot_status.setAlignment(Qt.AlignmentFlag.AlignCenter)
        layout.addWidget(self.aimbot_status)
        
        # Control buttons
        start_btn = QPushButton("Start Aimbot (F1)")
        start_btn.clicked.connect(self.toggle_aimbot)
        layout.addWidget(start_btn)
        
        settings_btn = QPushButton("Settings")
        settings_btn.clicked.connect(lambda: self.stacked_widget.setCurrentIndex(1))
        layout.addWidget(settings_btn)
        
        page.setLayout(layout)
        return page
    
    def create_settings_page(self):
        page = QWidget()
        layout = QVBoxLayout()
        
        # Settings title
        title = QLabel("Settings")
        title.setAlignment(Qt.AlignmentFlag.AlignCenter)
        title.setFont(QFont('Arial', 20, QFont.Weight.Bold))
        layout.addWidget(title)
        
        # Sensitivity settings
        self.xy_sens_input = QLineEdit()
        self.xy_sens_input.setPlaceholderText("X-Y Sensitivity")
        layout.addWidget(self.xy_sens_input)
        
        self.targeting_sens_input = QLineEdit()
        self.targeting_sens_input.setPlaceholderText("Targeting Sensitivity")
        layout.addWidget(self.targeting_sens_input)
        
        # Save button
        save_btn = QPushButton("Save Settings")
        save_btn.clicked.connect(self.save_settings)
        layout.addWidget(save_btn)
        
        # Back button
        back_btn = QPushButton("Back")
        back_btn.clicked.connect(lambda: self.stacked_widget.setCurrentIndex(0))
        layout.addWidget(back_btn)
        
        page.setLayout(layout)
        return page
    
    def setup_animations(self):
        self.fade_animation = QPropertyAnimation(self, b"windowOpacity")
        self.fade_animation.setDuration(500)
        self.fade_animation.setStartValue(0)
        self.fade_animation.setEndValue(1)
        self.fade_animation.setEasingCurve(QEasingCurve.Type.InOutQuad)
        
    def toggle_aimbot(self):
        if hasattr(self, 'aimbot_active') and self.aimbot_active:
            self.aimbot_active = False
            self.aimbot_status.setText("Aimbot Status: Inactive")
            if hasattr(self, 'aimbot'):
                self.aimbot.clean_up()
        else:
            self.aimbot_active = True
            self.aimbot_status.setText("Aimbot Status: Active")
            if hasattr(self, 'aimbot'):
                self.aimbot.update_status_aimbot()
    
    def save_settings(self):
        try:
            xy_sens = float(self.xy_sens_input.text())
            targeting_sens = float(self.targeting_sens_input.text())
            
            sensitivity_settings = {
                "xy_sens": xy_sens,
                "targeting_sens": targeting_sens,
                "xy_scale": 10/xy_sens,
                "targeting_scale": 1000/(targeting_sens * xy_sens)
            }
            
            path = "lib/config"
            if not os.path.exists(path):
                os.makedirs(path)
                
            with open('lib/config/config.json', 'w') as outfile:
                json.dump(sensitivity_settings, outfile)
                
            # Show success message
            self.statusBar().showMessage("Settings saved successfully!", 3000)
            
        except ValueError:
            self.statusBar().showMessage("Invalid input! Please enter valid numbers.", 3000)

def on_release(key):
    try:
        if key == keyboard.Key.f1:
            window.toggle_aimbot()
        if key == keyboard.Key.f2:
            if hasattr(window, 'aimbot'):
                window.aimbot.clean_up()
    except NameError:
        pass

def main():
    global window
    app = QApplication(sys.argv)
    window = LunarGUI()
    
    # Start fade-in animation
    window.show()
    window.fade_animation.start()
    
    # Setup keyboard listener
    listener = keyboard.Listener(on_release=on_release)
    listener.start()
    
    # Initialize aimbot if config exists
    if os.path.exists("lib/config/config.json"):
        from lib.aimbot import Aimbot
        window.aimbot = Aimbot(collect_data = "collect_data" in sys.argv)
    
    sys.exit(app.exec())

if __name__ == "__main__":
    os.system('cls' if os.name == 'nt' else 'clear')
    os.environ['PYGAME_HIDE_SUPPORT_PROMPT'] = '1'
    
    path_exists = os.path.exists("lib/data")
    if "collect_data" in sys.argv and not path_exists:
        os.makedirs("lib/data")
    
    main()