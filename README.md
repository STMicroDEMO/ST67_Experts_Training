# ST67_Experts_Training
**Overview**
---------------------------------------------------
Welcome to the ST67W611 Experts Training! This workshop will guide you through hands-on development with the ST67W611 module, covering Wi-Fi 6, Bluetooth® LE, and Thread connectivity. The workshop is hands-on, focusing on device setup, firmware flashing, BLE commissioning app development, and porting to new host MCUs using STM32Cube tools.

_**Agenda & Contents**_

1) **Device Setup & Flashing:**

Step-by-step guide to set up and flash the ST67W611 module using provided scripts and tools.

2) **X-CUBE-ST67W61 Software Package:**

Overview of the middleware, drivers, APIs, and example applications (BLE commissioning, Wi-Fi commissioning, Echo, HTTP server/client, MQTT, FOTA, etc.).

3) **Hands-on BLE Commissioning App Development:**

Using NUCLEO-U575ZI-Q and NUCLEO-G0B1RE as host processors.

Demonstrates provisioning Wi-Fi credentials via Bluetooth® LE.

4) **Porting to New Host MCUs:**

Using STM32CubeMX to adapt the solution to different STM32 boards.

Covers pin mapping, SPI/DMA configuration, FreeRTOS setup, and code generation.

5) **Documentation & Support:**

Access to API documentation, wikis, and ST support channels


**Reference Projects & Files**
-----------------------------------------
1) **ST67_G0_BLE_Commissioning_App:** This folder contains the complete working project of the BLE_Commissioning_app on the NUCLEO-G0B1RE as a host MCU with ST67.

NOTE: This is a hands-on session and will be covered step-by-step during the training. The project is provided as a reference implementation.

2) **Modified files (G0 port)** This folder contains only the modified files needed for the NUCLEO-G0B1RE Port hands-on session. Use these as a quick reference or to patch your own project during the workshop.

3) **Presentations:**
   
   a) ST67W611_Experts_Training.pdf (Main training presentation)
   
   b) ST67_Experts_Training_Prerequisites.pdf (Software Prerequisties to be installed before the training)

**Documentation & Resources**
---------------------------------------
API Documentation:
Included in the software package:
Middlewares\ST\ST67W6X_Network_Driver\Doc\ST67W6X_Network_Driver.chm

**Additional Notes**
----------------------------------------------------
Hardware will be provided before the workshop.

All software tools should be installed prior to the session.

For BLE commissioning, use the latest ST BLE Toolbox app (Android/iOS) or Web Bluetooth interface.

