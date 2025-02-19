local ui = fu.UIManager
local disp = bmd.UIDispatcher(ui)
local width, height = 220,110

comp = fu:GetCurrentComp()

app:AddConfig("RRanger", {
    Target {
        ID = "RRanger",
    },
    Hotkeys {
        Target = "RRanger",
        Defaults = true,
        ESCAPE = "Execute{cmd = [[app.UIManager:QueueEvent(obj, 'Close', {})]]}",
    },
})
function getBounds()
    compAttrs = comp:GetAttrs()
    rStart = compAttrs.COMPN_RenderStart
    rEnd = compAttrs.COMPN_RenderEnd
    return rStart, rEnd
end


function plusOffset(offset, s, e)
    comp:SetAttrs({COMPN_RenderStart = s + offset})
    comp:SetAttrs({COMPN_RenderEnd = e - offset})
end


function minusOffset(offset, s, e)
    comp:SetAttrs({COMPN_RenderStart = s - offset})
    comp:SetAttrs({COMPN_RenderEnd = e + offset})
end


function showUI()
    
    local x = fu:GetMousePos()[1]
    local y = fu:GetMousePos()[2]
    if y < 90 then
        y = 130
    end

    win = disp:AddWindow({
        ID = "RRanger",
        TargetID = "RRanger",
        WindowTitle = "Render Ranger",
        Geometry = {x+20, y, width, height},
        Spacing = 10,
        
        ui:VGroup{
        ID = 'root',
        -- GUI elements:
            ui:HGroup{
                ui:Label{
                    Weight = 0.8,
                    ID = 'Label',
                    Text = 'amount of frames to offset:',
                    Alignment = {AlignRight = true, AlignVCenter = true}
                },
                ui:LineEdit {
                    Weight = 0.2,
                    ID = 'offset', Text = tostring(24),
                    Alignment = {AlignCenter = true},
                    Events = {ReturnPressed = true},
                }
            },
            ui:HGroup{
                VMargin = 3,
                -- ui:VGap(20),
                ui:Button{
                    ID = 'minus', Text = '-',
                },
                    ui:Button{
                    ID = 'plus', Text = '+',
                    
                }
            },
            ui:VGroup{
                VMargin = 3,
                -- ui:VGap(20),
                ui:Button{
                    ID = 'reset', Text = 'reset globals',
                },
                -- ui:Button{
                --     ID = 'close', Text = 'close'
                -- },
            },
        }
    })
    itm = win:GetItems()
    itm.offset:SelectAll()
    function win.On.minus.Clicked(ev)
        local s, e = getBounds()
        local currentOffset = tonumber(itm.offset:GetText())
        plusOffset(currentOffset, s, e)
    end
    function win.On.plus.Clicked(ev)
        local s, e = getBounds()
        local currentOffset = tonumber(itm.offset:GetText())
        local gstart = comp:GetAttrs().COMPN_GlobalStart
        if s - currentOffset < 0 then
            comp:SetAttrs({COMPN_GlobalStart = s - currentOffset})
        end
        minusOffset(currentOffset, s, e)
    end
    function win.On.close.Clicked(ev)
        disp:ExitLoop()
    end
   
    function win.On.reset.Clicked(ev)
        gStart = comp:GetAttrs().COMPN_GlobalStart
        if gStart < 0 then
            gStart = 0
            comp:SetAttrs({COMPN_GlobalStart = 0})
        end
        gEnd = comp:GetAttrs().COMPN_GlobalEnd
        comp:SetAttrs({COMPN_RenderStart = gStart})
        comp:SetAttrs({COMPN_RenderEnd = gEnd})
    end

    function win.On.RRanger.Close(ev)
        disp:ExitLoop()
    end


    win:Show()
    disp:RunLoop()
    win:Hide()
end

showUI()
