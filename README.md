# Flutter - StrixPassword Manager

 A Password manager coded entirely in Flutter that used Three layers of security. It saves password in your Phone's local Storage, thus no issue of data Leak from a server. 

    - Support Local Storage Only as of now
    - Not for web
    - You can easily add Custom Backend
    
# Author
* Sree Harsha - aka [HarshaStrix][website]
* My Portfolio Website - [(myfolio-strixblog)][website]

[website]: https://myfolio-strixblog.web.app/

# Security Layers
    1. Your password String is Encrypted itself.
    2. The Entire Database is encrypted.
    3. Uses Your Phone's Local Bio (Fingerprint) auth.
        - Also it is single-time Allow only, 
          which means if you press home or back, You will have to re-authenticate.

# Security 
    - need to re-authenticate every time app is launched
    - Won't be visible in recent - activity
    - Local Authentication ( Bio )
    - Database is encrypted
    - Passwords are encrypted
    - App Level security

# Data
    - type
    - nick
    - username/email
    - password

# Screenshots

### Local Auth via Fingerprint / PIN
<p align="center">
  <img src="screenshots/1.jpg" width="350">
</p>

### Local Auth via Fingerprint
<p align="center">
  <img src="screenshots/2.png" width="350">
</p>

### Your passwords screen
<p align="center">
  <img src="screenshots/3.jpg" width="350">
</p>

### Add button functionality
<p align="center">
  <img src="screenshots/4.jpg" width="350">
</p>

### Your added credentials 
<p align="center">
  <img src="screenshots/5.jpg" width="350">
</p>

### Edit & Delete option
<p align="center">
  <img src="screenshots/6.jpg" width="350">
</p>

### Password will be copied to your Clipboard
<p align="center">
  <img src="screenshots/7.jpg" width="350">
</p>

# Todos
    - add Delete
    - add Edit
    - add a text-auto-fill for correctly mapping icons to service

  
