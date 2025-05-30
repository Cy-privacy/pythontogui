# -*- mode: python ; coding: utf-8 -*-

block_cipher = None

a = Analysis(
    ['lunar.py'],
    pathex=[],
    binaries=[],
    datas=[
        ('lib/config', 'lib/config'),
        ('lib/data', 'lib/data')
    ],
    hiddenimports=[
        'PyQt6',
        'qt_material',
        'pynput',
        'torch',
        'torchvision',
        'ultralytics',
        'mss',
        'pygame',
        'termcolor'
    ],
    hookspath=[],
    hooksconfig={},
    runtime_hooks=[],
    excludes=[],
    win_no_prefer_redirects=False,
    win_private_assemblies=False,
    cipher=block_cipher,
    noarchive=False,
    collect_all=['torch', 'torchvision', 'ultralytics']
)

pyz = PYZ(a.pure, a.zipped_data, cipher=block_cipher)

exe = EXE(
    pyz,
    a.scripts,
    a.binaries,
    a.zipfiles,
    a.datas,
    [],
    name='Lunar',
    debug=False,
    bootloader_ignore_signals=False,
    strip=False,
    upx=True,
    upx_exclude=[],
    runtime_tmpdir=None,
    console=True,
    disable_windowed_traceback=False,
    target_arch=None,
    codesign_identity=None,
    entitlements_file=None,
    icon='icon.ico'
)