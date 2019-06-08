-- v1.0 Initial script created by Sven Neve
-- v1.1 22.02.2019 fix compatibility with Fusion 9+
-- v1.2 15.05.2019 fix slow copy/paste Loaders issue, simplify error checking

local originalToolList = comp:GetToolList(true)
flow = comp.CurrentFrame.FlowView
composition:StartUndo("Duplicate")
comp:Copy(originalToolList)
comp:SetActiveTool()
flow:Select()
comp:Paste()
local duplicateToolList = comp:GetToolList(true)

for tool_index, tool in pairs(originalToolList) do
	for input_index, input in pairs(tool:GetInputList()) do
		if input:GetAttrs().INPB_Connected then
            if not duplicateToolList[tool_index]:GetInputList()[input_index]:GetAttrs().INPB_Connected then
                duplicateToolList[tool_index]:GetInputList()[input_index]:ConnectTo(input:GetConnectedOutput())
            end
		end
	end
end
composition:EndUndo("Duplicate")
