--[[
	Prediction Library
	Source: https://devforum.roblox.com/t/predict-projectile-ballistics-including-gravity-and-motion/1842434
	New Solver: https://devforum.roblox.com/t/trajectory-prediction/3350931

	NOTICE: This library has been altered with artifical inteligence (Opencode - Big Pickle)
]]

local module = {}
local eps = 1e-9
local function isZero(d)
	return (d > -eps and d < eps)
end

local function cuberoot(x)
	return (x > 0) and math.pow(x, (1 / 3)) or -math.pow(math.abs(x), (1 / 3))
end

local function solveQuadric(c0, c1, c2)
	local s0, s1

	local p, q, D

	p = c1 / (2 * c0)
	q = c2 / c0
	D = p * p - q

	if isZero(D) then
		s0 = -p
		return s0
	elseif (D < 0) then
		return
	else -- if (D > 0)
		local sqrt_D = math.sqrt(D)

		s0 = sqrt_D - p
		s1 = -sqrt_D - p
		return s0, s1
	end
end

local function solveCubic(c0, c1, c2, c3)
	local s0, s1, s2

	local num, sub
	local A, B, C
	local sq_A, p, q
	local cb_p, D

	A = c1 / c0
	B = c2 / c0
	C = c3 / c0

	sq_A = A * A
	p = (1 / 3) * (-(1 / 3) * sq_A + B)
	q = 0.5 * ((2 / 27) * A * sq_A - (1 / 3) * A * B + C)

	cb_p = p * p * p
	D = q * q + cb_p

	if isZero(D) then
		if isZero(q) then -- one triple solution
			s0 = 0
			num = 1
		else -- one single and one double solution
			local u = cuberoot(-q)
			s0 = 2 * u
			s1 = -u
			num = 2
		end
	elseif (D < 0) then -- Casus irreducibilis: three real solutions
		local phi = (1 / 3) * math.acos(-q / math.sqrt(-cb_p))
		local t = 2 * math.sqrt(-p)

		s0 = t * math.cos(phi)
		s1 = -t * math.cos(phi + math.pi / 3)
		s2 = -t * math.cos(phi - math.pi / 3)
		num = 3
	else -- one real solution
		local sqrt_D = math.sqrt(D)
		local u = cuberoot(sqrt_D - q)
		local v = -cuberoot(sqrt_D + q)

		s0 = u + v
		num = 1
	end

	sub = (1 / 3) * A

	if (num > 0) then s0 = s0 - sub end
	if (num > 1) then s1 = s1 - sub end
	if (num > 2) then s2 = s2 - sub end

	return s0, s1, s2
end

function module.solveQuartic(c0, c1, c2, c3, c4)
	local s0, s1, s2, s3

	local coeffs = {}
	local z, u, v, sub
	local A, B, C, D
	local sq_A, p, q, r
	local num

	A = c1 / c0
	B = c2 / c0
	C = c3 / c0
	D = c4 / c0

	sq_A = A * A
	p = -0.375 * sq_A + B
	q = 0.125 * sq_A * A - 0.5 * A * B + C
	r = -(3 / 256) * sq_A * sq_A + 0.0625 * sq_A * B - 0.25 * A * C + D

	if isZero(r) then
		coeffs[3] = q
		coeffs[2] = p
		coeffs[1] = 0
		coeffs[0] = 1

		local results = {solveCubic(coeffs[0], coeffs[1], coeffs[2], coeffs[3])}
		num = #results
		s0, s1, s2 = results[1], results[2], results[3]
	else
		coeffs[3] = 0.5 * r * p - 0.125 * q * q
		coeffs[2] = -r
		coeffs[1] = -0.5 * p
		coeffs[0] = 1

		s0, s1, s2 = solveCubic(coeffs[0], coeffs[1], coeffs[2], coeffs[3])
		z = s0

		u = z * z - r
		v = 2 * z - p

		if isZero(u) then
			u = 0
		elseif (u > 0) then
			u = math.sqrt(u)
		else
			return
		end
		if isZero(v) then
			v = 0
		elseif (v > 0) then
			v = math.sqrt(v)
		else
			return
		end

		coeffs[2] = z - u
		coeffs[1] = q < 0 and -v or v
		coeffs[0] = 1

		do
			local results = {solveQuadric(coeffs[0], coeffs[1], coeffs[2])}
			num = #results
			s0, s1 = results[1], results[2]
		end

		coeffs[2] = z + u
		coeffs[1] = q < 0 and v or -v
		coeffs[0] = 1

		if (num == 0) then
			local results = {solveQuadric(coeffs[0], coeffs[1], coeffs[2])}
			num = num + #results
			s0, s1 = results[1], results[2]
		end
		if (num == 1) then
			local results = {solveQuadric(coeffs[0], coeffs[1], coeffs[2])}
			num = num + #results
			s1, s2 = results[1], results[2]
		end
		if (num == 2) then
			local results = {solveQuadric(coeffs[0], coeffs[1], coeffs[2])}
			num = num + #results
			s2, s3 = results[1], results[2]
		end
	end

	sub = 0.25 * A

	if (num > 0) then s0 = s0 - sub end
	if (num > 1) then s1 = s1 - sub end
	if (num > 2) then s2 = s2 - sub end
	if (num > 3) then s3 = s3 - sub end

	return {s3, s2, s1, s0}
end

--[[function module.NewTrajectory(
	origin: Vector3,
	originVelo: Vector3,
	gravity: Vector3,
	targetPos: Vector3,
	targetVelocity: Vector3,
	targetAccel: Vector3,
	projectileSpeed: number,
	pickLongest: boolean?
)
	local p = targetPos-origin
	local v = targetVelocity-originVelo
	local a = targetAccel-gravity

	local t = {
		(a.X^2 + a.Y^2 + a.Z^2)/4,
		a.X*v.X + a.Y*v.Y + a.Z*v.Z,
		v.X^2 + p.X*a.X + v.Y^2 + p.Y*a.Y + v.Z^2 + p.Z*a.Z - projectileSpeed^2,
		2 * (p.X*v.X + p.Y*v.Y + p.Z*v.Z),
		p.X^2 + p.Y^2 + p.Z^2,
	}

	local solutions = module.solveQuartic(table.unpack(t))
	if solutions then
		local posRoots: {number} = table.create(4)
		for _, v in solutions do
			if v > 0 then
				table.insert(posRoots, v)
			end
		end

		if posRoots[1] then
			local t: number = posRoots[pickLongest and #posRoots or 1]
			return targetPos + v * t + 0.5 * a * t * t, t
		end
	end

	if a.Magnitude < 0.01 and p.Magnitude < projectileSpeed then
		local t: number = p.Magnitude / projectileSpeed
		return targetPos + v * t, t
	end
end

function module.SolveTrajectory(origin, projectileSpeed, gravity, targetPos, targetVelocity, playerGravity, playerHeight, playerJump, params)
	return module.NewTrajectory(origin, Vector3.zero, Vector3.new(0, -gravity, 0), targetPos, targetVelocity, Vector3.zero, projectileSpeed)
end]]

--[[
	targets do not travel in a straight line while they are airborne, a spam jumping
	target is walked through the jump arc it is currently in and through the arcs it
	repeats once it lands again so the predicted height stays on top of it
]]
local function jumpDisplacement(gravity, jump, velo, time)
	local cycle = 2 * jump / gravity
	local elapsed = (jump - velo) / gravity
	local airborne = jump * elapsed - .5 * gravity * elapsed * elapsed

	local current = elapsed + time
	if current >= cycle then
		current = current % cycle
	end

	return jump * current - .5 * gravity * current * current - airborne
end

--[[
	vertical displacement of the target after `time` seconds, a target which is not
	inside a jump arc keeps falling until it reaches the ground it departed from
]]
local function verticalDisplacement(playerGravity, playerJump, velo, time)
	if not playerGravity or playerGravity <= 0 then
		return velo * time
	elseif playerJump and playerJump > 0 and math.abs(velo) <= playerJump then
		return jumpDisplacement(playerGravity, playerJump, velo, time)
	elseif velo > 0 then
		local landed = -(velo * velo) / (2 * playerGravity)
		local fallen = velo * time - .5 * playerGravity * time * time
		return fallen < landed and landed or fallen
	end

	return velo * time
end

function module.SolveTrajectory(origin, projectileSpeed, gravity, targetPos, targetVelocity, playerGravity, playerHeight, playerJump, params)
	local disp = targetPos - origin
	local h, j, k = disp.X, disp.Y, disp.Z
	local p, q, r = targetVelocity.X, targetVelocity.Y, targetVelocity.Z

	if projectileSpeed <= 0 then
		return
	end

	--[[ launch speed the shot needs to reach the spot the target is going to be in
		after `time` seconds, aiming half of the drop above it lands the projectile
		back down on that spot ]]
	local function launchSpeed(time)
		local drop = .5 * gravity * time
		local x, z = (h + (p * time)) / time, (k + (r * time)) / time
		local y = ((j + verticalDisplacement(playerGravity, playerJump or 0, q, time)) / time) + drop
		return math.sqrt((x * x) + (y * y) + (z * z))
	end

	--[[ the target travels further the longer the shot takes and the shot takes longer
		the further the target travels, a bouncing target makes the launch speed dip in
		and back out of reach, so the time is scanned for the first spot the shot fits
		and then bisected down onto it ]]
	local low, high = 0, 0.02
	while high <= 3 and launchSpeed(high) > projectileSpeed do
		low = high
		high = high + 0.02
	end

	if launchSpeed(high) > projectileSpeed then
		return
	end

	for i = 1, 10 do
		local mid = (low + high) / 2
		if launchSpeed(mid) > projectileSpeed then
			low = mid
		else
			high = mid
		end
	end

	local time = high
	local bounce = verticalDisplacement(playerGravity, playerJump, q, time)
	return origin + Vector3.new(h + (p * time), j + bounce + (.5 * gravity * time * time), k + (r * time))
end

return module