local function drawVerticalGauge(x, y, size, width, value, max)
  local val = value
  if val<0 then
    val=0
  end
  if val>max then
    val=max
  end
  local sz_filled = val*(size/max)
  local sz_unfilled = size-sz_filled
  lcd.drawRectangle(x, y-size, width, sz_unfilled)
  lcd.drawFilledRectangle(x, y-sz_filled, width, sz_filled)
end

local function drawServo(x, y, size, width, value, max)
  local val = value
  if val<((-1)*max) then
    val=(-1)*max
  end
  if val>max then
    val=max
  end
  lcd.drawRectangle(x, y, size*2, width)
  if val>0 then
    local sz_filled = val*(size/max)
    lcd.drawFilledRectangle(x+size-sz_filled, y, sz_filled, width)
  else
    if val<0 then
      local sz_filled = (-1)*val*(size/max)
      lcd.drawFilledRectangle(x+size, y, sz_filled, width)
    else
      lcd.drawLine(x+size, y, x+size, y+width-1, SOLID, FORCE)
    end
  end
end

local function SecondsToClock(seconds)
  local seconds = tonumber(seconds)

  if seconds <= 0 then
    return "00:00:00";
  else
    local hours = string.format("%02.f", math.floor(seconds/3600));
    local mins = string.format("%02.f", math.floor(seconds/60 - (hours*60)));
    local secs = string.format("%02.f", math.floor(seconds - hours*3600 - mins *60));
    return hours..":"..mins..":"..secs
  end
end

local function bgrnd_func()
  lcd.clear()

end

local function run(event)
  bgrnd_func()
  lcd.drawPixmap(60, 0, "/SCRIPTS/BMP/765.bmp")

  -- Front outputs
  lcd.drawText(2, 1, "SA", SMLSIZE)
  lcd.drawGauge(15, 1, 20, 6, 100+(getValue('ch3')/10), 200)
  lcd.drawText(2, 8, "SB", SMLSIZE)
  lcd.drawGauge(15, 8, 20, 6, 100+(getValue('ch5')/10), 200)
  lcd.drawText(2, 15, "S1", SMLSIZE)
  lcd.drawGauge(15, 15, 20, 6, 100+(getValue('ch6')/10), 200)

  -- Front lift
  lcd.drawText(2, 38, "SF", SMLSIZE)
  lcd.drawText(5, 45, "+", SMLSIZE)
  lcd.drawText(2, 52, "LS", SMLSIZE)
  drawVerticalGauge(15, 63, 40, 6, 100+(getValue('ch7')/10), 200)

  -- Rear outputs
  lcd.drawText(200, 1, "SC", SMLSIZE)
  lcd.drawGauge(176, 1, 20, 6, 100+(getValue('ch11')/10), 200)
  lcd.drawText(200, 8, "SD", SMLSIZE)
  lcd.drawGauge(176, 8, 20, 6, 100+(getValue('ch12')/10), 200)
  lcd.drawText(200, 15, "Vit", SMLSIZE)
  drawServo(176, 15, 10, 6, getValue('ch13')/10, 100)
  lcd.drawText(141, 1, "S2", SMLSIZE)
  lcd.drawGauge(154, 1, 20, 6, 100+(getValue('ch14')/10), 200)
  lcd.drawText(141, 8, "YDr", SMLSIZE)
  lcd.drawGauge(154, 8, 20, 6, 100+(getValue('ch15')/10), 200)
  lcd.drawText(141, 15, "SH", SMLSIZE)
  lcd.drawGauge(154, 15, 20, 6, 100+(getValue('ch16')/10), 200)

  -- Rear lift
  lcd.drawText(200, 38, "SE", SMLSIZE)
  lcd.drawText(202, 45, "+", SMLSIZE)
  lcd.drawText(200, 52, "RS", SMLSIZE)
  drawVerticalGauge(191, 63, 40, 6, 100+(getValue('ch9')/10), 200)

  -- Power
  lcd.drawChannel(72, 0, "Curr", DBLSIZE)
  lcd.drawChannel(62, 16, "Curr+", SMLSIZE)
  lcd.drawChannel(65, 43, "VFAS", DBLSIZE)
  lcd.drawChannel(65, 58, "BtRx", SMLSIZE)
  lcd.drawChannel(50, 58, "tx-voltage", SMLSIZE)

  -- Speed
  drawServo(76, 44, 28, 6, getValue('ch2')/10, 100)
  drawServo(76, 51, 28, 6, getValue('ch1')/10, 100)
  lcd.drawText(90, 58, "SG + YGa", SMLSIZE)
  drawVerticalGauge(134, 63, 20, 6, 100+(getValue('sg')/10), 200)

  -- Various
  -- drawDate(32, 1)
  lcd.drawText(141, 42,"SWR", SMLSIZE)
  lcd.drawText(141, 49,"RssI", SMLSIZE)
  -- lcd.drawText(141, 56,"Ar", SMLSIZE)
  lcd.drawChannel(172, 42, "SWR", SMLSIZE)
  lcd.drawChannel(172, 49, "RSSI", SMLSIZE)
  local datenow = getDateTime()
  lcd.drawText(141, 56, datenow.hour..":"..datenow.min..":"..datenow.sec, SMLSIZE)

  -- linking lines
  -- (for servos)
  lcd.drawLine(24, 21, 24, 31, SOLID, FORCE)
  lcd.drawLine(24, 31, 58, 31, SOLID, FORCE)
  lcd.drawLine(24, 34, 58, 34, SOLID, FORCE)
  lcd.drawLine(164, 22, 164, 28, SOLID, FORCE)
  lcd.drawLine(164, 28, 140, 28, SOLID, FORCE)
  lcd.drawLine(188, 22, 188, 31, SOLID, FORCE)
  lcd.drawLine(188, 31, 140, 31, SOLID, FORCE)
  lcd.drawLine(188, 34, 140, 34, SOLID, FORCE)
  -- (for power)
  lcd.drawLine(72, 8, 78, 8, SOLID, FORCE)
  lcd.drawLine(78, 8, 78, 14, SOLID, FORCE)
  lcd.drawLine(65, 51, 74, 51, SOLID, FORCE)
  lcd.drawLine(74, 51, 74, 40, SOLID, FORCE)
end

return { background=bgrnd_func, run=run }