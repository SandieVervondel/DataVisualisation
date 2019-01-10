# Concept visualisation 2

Work process:
  - Retrieve data in Processing from API (https://1forge.com/forex-data-api). In case there are problems with the internet or the api, I made a backup version with offline data
  - Send the current exchange rate to Pure Data using Open Sound Control
  - Control sound using Pure Data. For this I used the Pure Data library Automatonism. All the audio creation is in the patch main.pd, the actual receiving of the data and adapting of the audio is done in the patch sonification.pd
  
  
Goal:
  - Give a representation of the current exchange rates
  
  
Attributes: 
  - Explanatory
  - Auditive
  - Node-based
  
