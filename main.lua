debug = true

--player stats
player = {x = 200, y = 510, speed = 225, img = nil}
isAlive = true
score = 0

--boss stats
boss = {x = 200, y = 0, speed = 100, img = nil, hp = -50, moving = false, direction = 'nil'}

--enemy stats
createEnemyTimerMax = 0.4
createEnemyTimer = createEnemyTimerMax
enemyImg = nil
enemies = {}

--bullet stats
canShoot = true
canShootTimerMax = 0.3
canShootTimer = canShootTimerMax
bulletImg = nil
bullets = {}

--boss bullet stats
canShootBoss = true
canShootTimerMaxBoss = 1
canShootTimerBoss = canShootTimerMaxBoss
bulletImgBoss = nil
bulletsBoss = {}

--check collision of bullets and planes
function CheckCollision(x1,y1,w1,h1, x2,y2,w2,h2)
  return x1 < x2+w2 and
         x2 < x1+w1 and
         y1 < y2+h2 and
         y2 < y1+h1
end

function love.load(arg)
<<<<<<< HEAD
  --load assets
=======
>>>>>>> origin/master
  gunshot = love.audio.newSource('assets/gun-sound.wav', "static")
	player.img = love.graphics.newImage('assets/plane.png')
  boss.img = love.graphics.newImage('assets/boss.png')
	bulletImg = love.graphics.newImage('assets/bullet.png')
	enemyImg = love.graphics.newImage('assets/enemy.png')
end

function love.update(dt)
  --reset firing of player
	canShootTimer = canShootTimer - (1 * dt)
	if canShootTimer < 0 then
  		canShoot = true
	end

  --reset firing of boss
	canShootTimerBoss = canShootTimerBoss - (1 * dt)
	if canShootTimerBoss < 0 then
  		canShootBoss = true
	end

  --quit the game
	if love.keyboard.isDown('escape') then
		love.event.push('quit')
	end

  --movement
	if love.keyboard.isDown('left', 'a') then
		if player.x > 0 then
			player.x = player.x - (player.speed*dt)
		end
	elseif love.keyboard.isDown('right', 'd') then
		if player.x < (love.graphics:getWidth() - player.img:getWidth()) then
			player.x = player.x + (player.speed*dt)
		end
  elseif love.keyboard.isDown('up', 'w') then
    if player.y > (love.graphics:getHeight()/2) then
      player.y = player.y - (player.speed*dt)
    end
  elseif love.keyboard.isDown('down', 's') then
    if player.y < (love.graphics:getHeight() - player.img:getHeight()) then
      player.y = player.y + (player.speed*dt)
    end
	end

<<<<<<< HEAD
  --shooting
  if love.keyboard.isDown(' ', 'rctrl', 'lctrl', 'ctrl') and canShoot and isAlive then
  	newBullet = { x = player.x + (player.img:getWidth()/2), y = player.y, img = bulletImg}
  	table.insert(bullets, newBullet)
  	canShoot = false
	  canShootTimer = canShootTimerMax
    gunshot:play()
  end

  --boss shooting
  if boss.hp > 0 and canShootBoss then
  	newBulletBoss = { x = boss.x + (boss.img:getWidth()/2), y = boss.y + boss.img:getHeight(), img = bulletImg}
  	table.insert(bulletsBoss, newBulletBoss)
  	canShootBoss = false
	  canShootTimerBoss = canShootTimerMaxBoss
    gunshot:play()
  end
=======
--shooting
if love.keyboard.isDown(' ', 'rctrl', 'lctrl', 'ctrl') and canShoot and isAlive then
	newBullet = { x = player.x + (player.img:getWidth()/2), y = player.y, img = bulletImg }
	table.insert(bullets, newBullet)
	canShoot = false
	canShootTimer = canShootTimerMax
  gunshot:play()
end
>>>>>>> origin/master

  --bullet movement and cleanup
	for i, bullet in ipairs(bullets) do
		bullet.y = bullet.y - (250 * dt)

  		if bullet.y < 0 then
			table.remove(bullets, i)
		end
	end

  --boss bullet movement and cleanup
	for i, bulletBoss in ipairs(bulletsBoss) do
		bulletBoss.y = bulletBoss.y + (500 * dt)

  		if bulletBoss.y > 600 then
			table.remove(bulletsBoss, i)
		end
	end

  --enemy generator
	createEnemyTimer = createEnemyTimer - (1*dt)
	if createEnemyTimer < 0  and score < 5 then
		createEnemyTimer = createEnemyTimerMax

		randomNumber = math.random(10, love.graphics.getWidth() - 10)
		newEnemy = {x = randomNumber, y = -10, img = enemyImg}
		table.insert(enemies, newEnemy)
	end

  --initiate boss fight
  if score == 10 and boss.hp == -50 then
    boss.hp = 10
  end

  --boss destination
  if boss.hp > 0 and boss.moving == false then
    randommove = math.random(480 - boss.img:getWidth())
    if randommove < boss.x then
      boss.direction = 'left'
    else
      boss.direction = 'right'
    end
    boss.moving = true
  end

  --boss movement
  if boss.moving == true then
    if boss.direction == 'right' then
      boss.x = boss.x + boss.speed*dt
    else
      boss.x = boss.x - boss.speed*dt
    end

    if boss.direction == 'right' and boss.x > randommove then
      boss.moving = false
    end
    if boss.direction == 'left' and boss.x < randommove then
      boss.moving = false
    end
  end

  --enemy movement and cleanup
	for i, enemy in ipairs(enemies) do
		enemy.y = enemy.y + (200 * dt)

		if enemy.y > 650 then
			table.remove(enemies, i)
		end
	end

	for i, enemy in ipairs(enemies) do
    --collision check for enemies and bullets
		for j, bullet in ipairs(bullets) do
			if CheckCollision(enemy.x, enemy.y, enemy.img:getWidth(), enemy.img:getHeight(),
			bullet.x, bullet.y, bullet.img:getWidth(), bullet.img:getHeight()) then
				table.remove(bullets, j)
				table.remove(enemies, i)
				score = score + 1
			end
		end


    --collision check for player and enemies
		if CheckCollision(enemy.x, enemy.y, enemy.img:getWidth(), enemy.img:getHeight(), player.x, player.y,
		 player.img:getWidth(), player.img:getHeight()) and isAlive then
			table.remove(enemies, i)
      boss.hp = -50
			isAlive = false
		end
	end

  --collision check for boss and bullets
  for j, bullet in ipairs(bullets) do
    if CheckCollision(boss.x, boss.y, boss.img:getWidth(), boss.img:getHeight(),
    bullet.x, bullet.y, bullet.img:getWidth(), bullet.img:getHeight()) then
      table.remove(bullets, j)
      boss.hp = boss.hp - 1
      if boss.hp > 0 then
        score = score + 1
      end
    end
  end

  --collision check for player and bullets
  for j, bulletBoss in ipairs(bulletsBoss) do
    if CheckCollision(player.x, player.y, player.img:getWidth(), player.img:getHeight(),
    bulletBoss.x, bulletBoss.y, bulletBoss.img:getWidth(), bulletBoss.img:getHeight()) then
      table.remove(bullets, j)
      boss.hp = -50
      isAlive = false
    end
  end

  --reset game after dying
	if not isAlive and love.keyboard.isDown('r') then
		bullets = {}
		enemies = {}

		canShootTimer = canShootTimerMax
		createEnemyTimer = createEnemyTimerMax

		player.x = 50
		player.y = 510

		score = 0
		isAlive = true
	end
end

function love.draw(dt)
  --draw score
	love.graphics.print("Score = " .. score, 0, 0)

  if boss.hp > 0 then
    love.graphics.print("Boss HP: " .. boss.hp, 0, 20)
  end

  --draw player
	if isAlive then
		love.graphics.draw(player.img, player.x, player.y)
	else
		love.graphics.print("Press 'R' to restart", love.graphics:getWidth()/2-50, love.graphics:getHeight()/2-10)
	end

  --draw boss
  if boss.hp > 0 then
    love.graphics.draw(boss.img, boss.x, boss.y)
  end

  --draw bullets
	for i, bullet in ipairs(bullets) do
  		love.graphics.draw(bullet.img, bullet.x, bullet.y)
	end

  --draw boss bullets
  for i, bulletBoss in ipairs(bulletsBoss) do
    love.graphics.draw(bulletBoss.img, bulletBoss.x, bulletBoss.y)
	end

  --draw enemies
	for i, enemy in ipairs(enemies) do
		love.graphics.draw(enemy.img, enemy.x, enemy.y)
	end
end
