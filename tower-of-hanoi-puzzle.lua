local platform1, platform2, platform3 = workspace.Platform1, workspace.Platform2, workspace.Platform3
local rod1, rod2, rod3 = {}, {}, {}

local numrings = 50

local function createRingsAtLocation(platform)
  local rings = {}
  local switchColor = false
  for i = 1, numrings do
    rings[#rings + 1] = Instance.new("Part")
    rings[#rings].Color = Color3.new(math.cos(i / numrings), i / numrings, math.sin(i / numrings))
    --rings[#rings].Shape = "Cylinder"
    rings[#rings].Size = Vector3.new(platform.Size.X * (1 - (i / (numrings))), 1, platform.Size.X * (1 - (i / (numrings))))
    rings[#rings].Anchored = true
    rings[#rings].CFrame = platform.CFrame * CFrame.new(0, 1 + i, 0)
    rings[#rings].Parent = workspace
  end
  return rings
end

local function moveTopRingToTopOfStack(from, to)
  local currentRing = nil
  local stackSize = 0
  if from.Name == "Platform1" then
    currentRing = rod1[#rod1]
    table.remove(rod1, #rod1)

  elseif from.Name == "Platform2" then
    currentRing = rod2[#rod2]
    table.remove(rod2, #rod2)

  elseif from.Name == "Platform3" then
    currentRing = rod3[#rod3]
    table.remove(rod3, #rod3)
  end
  if to.Name == "Platform1" then
    stackSize = #rod1
    rod1[#rod1 + 1] = currentRing
  elseif to.Name == "Platform2" then
    stackSize = #rod2
    rod2[#rod2 + 1] = currentRing

  elseif to.Name == "Platform3" then
    stackSize = #rod3
    rod3[#rod3 + 1] = currentRing
  end

  currentRing.CFrame = to.CFrame * CFrame.new(0, 1 + stackSize, 0)
end


local function repositionTowerOfHanoi(currentStack, from_rod, to_rod, aux_rod)
  if (currentStack == 1) then
    moveTopRingToTopOfStack(from_rod, to_rod)

    --print("\n Move disk 1 from rod ", from_rod, " to rod ", to_rod)
    return
  end
  wait()
  moveTopRingToTopOfStack(from_rod, aux_rod)
  repositionTowerOfHanoi(currentStack - 1, from_rod, aux_rod, to_rod);
  wait()
  moveTopRingToTopOfStack(to_rod, aux_rod)
  repositionTowerOfHanoi(currentStack - 1, aux_rod, to_rod, from_rod);
end

local function moveTower()
  rod1 = createRingsAtLocation(platform1); -- A, B and C are names of rods
  wait(2)
  repositionTowerOfHanoi(numrings, platform1, platform2, platform3)
end

moveTower()
