---- #########################################################################
---- #                                                                       #
---- # Tractor monitoring Widget script for FrSky Horus                      #
---- # Copyright (C) OpenTX                                                  #
-----#                                                                       #
---- # License GPLv2: http://www.gnu.org/licenses/gpl-2.0.html               #
---- #                                                                       #
---- # This program is free software; you can redistribute it and/or modify  #
---- # it under the terms of the GNU General Public License version 2 as     #
---- # published by the Free Software Foundation.                            #
---- #                                                                       #
---- # This program is distributed in the hope that it will be useful        #
---- # but WITHOUT ANY WARRANTY; without even the implied warranty of        #
---- # MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         #
---- # GNU General Public License for more details.                          #
---- #                                                                       #
---- #########################################################################

local options = {
  { "Option1", SOURCE, 1 },
  { "Option2", VALUE, 1000 },
  { "Option3", COLOR, RED }
}

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
  lcd.drawFilledRectangle(x, y-sz_filled, width, sz_filled, CURVE_COLOR)
  lcd.drawRectangle(x, y-size, width, sz_unfilled, BLACK, 1)
end

local function drawServo(x, y, size, width, value, max)
  local val = value
  if val<((-1)*max) then
    val=(-1)*max
  end
  if val>max then
    val=max
  end
  lcd.drawRectangle(x, y, size*2, width, BLACK, 1)
  if val>0 then
    local sz_filled = val*(size/max)
    lcd.drawFilledRectangle(x+size-sz_filled, y, sz_filled, width, CURVE_COLOR)
  else
    if val<0 then
      local sz_filled = (-1)*val*(size/max)
      lcd.drawFilledRectangle(x+size, y, sz_filled, width, CURVE_COLOR)
    else
      lcd.drawLine(x+size, y, x+size, y+width-1, CURVE_COLOR, 1)
    end
  end
end

local function create(zone, options)
  local pie = { zone=zone, options=options, bitmap = Bitmap.open("/IMAGES/stx535.png") }
  return pie
end

local function update(pie, options)
  pie.options = options
end

local function background(pie)
end

function refresh(pie)
  -- lcd.setColor(CUSTOM_COLOR, lcd.RGB(0,102,0))
  lcd.setColor(CUSTOM_COLOR, WHITE)
  lcd.drawBitmap(pie.bitmap, pie.zone.x+85, pie.zone.y-10, 100)

  -- Rear outputs
  lcd.drawText(pie.zone.x+pie.zone.w-20, pie.zone.y, "SC", SMLSIZE+TEXT_COLOR)
  lcd.drawGauge(pie.zone.x+pie.zone.w-64, pie.zone.y+2, 40, 10, 100+(getValue('ch5')/10), 200, CURVE_COLOR)

  -- Rear lift
  lcd.drawText(pie.zone.x+pie.zone.w-20, pie.zone.y+55, "SE", SMLSIZE+TEXT_COLOR)
  lcd.drawText(pie.zone.x+pie.zone.w-17, pie.zone.y+65, "+", SMLSIZE+TEXT_COLOR)
  lcd.drawText(pie.zone.x+pie.zone.w-20, pie.zone.y+75, "RS", SMLSIZE+TEXT_COLOR)
  drawVerticalGauge(pie.zone.x+pie.zone.w-39, pie.zone.y+103, 60, 10, 100+(getValue('ch9')/10), 200)

  -- Power
  lcd.drawChannel(pie.zone.x+55, pie.zone.y-5, "VFAS", DBLSIZE+TEXT_COLOR)
  lcd.drawChannel(pie.zone.x+55, pie.zone.y+20, "Curr", DBLSIZE+TEXT_COLOR)
  lcd.drawText(pie.zone.x+30, pie.zone.y+47, "max", SMLSIZE+TEXT_COLOR)
  lcd.drawChannel(pie.zone.x+65, pie.zone.y+47, "Curr+", SMLSIZE+TEXT_COLOR)

  lcd.drawText(pie.zone.x+30, pie.zone.y+58, "RssI", SMLSIZE+TEXT_COLOR)
  lcd.drawChannel(pie.zone.x+65, pie.zone.y+58, "RSSI", SMLSIZE+TEXT_COLOR+BOLD)
  lcd.drawText(pie.zone.x+30, pie.zone.y+69, "RxBt", SMLSIZE+TEXT_COLOR)
  lcd.drawChannel(pie.zone.x+65, pie.zone.y+69, "RxBt", SMLSIZE+MENU_TITLE_BGCOLOR+BOLD)

  -- Speed
  lcd.drawText(pie.zone.x+pie.zone.w-20, pie.zone.y+pie.zone.h-30, "6P", SMLSIZE+TEXT_COLOR)
  drawVerticalGauge(pie.zone.x+pie.zone.w-32, pie.zone.y+pie.zone.h-11, 23, 10, 100+(getValue('6P')/10), 200)

end

return { name="STX535", options=options, create=create, update=update, refresh=refresh, background=background }
