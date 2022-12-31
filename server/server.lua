ESX.RegisterServerCallback('CarFuel:GetInfoSV', function(source, cb, carPlate, carModel)

    MySQL.Async.fetchAll('SELECT fuel, consumos FROM owned_vehicles WHERE plate = @plate',{['@plate'] = carPlate}, function(result)
        if result and result[1] ~= nil then
            cb(result[1].fuel, result[1].consumos)
        else
            local randomFuel = math.random(1,100)
            local defaultConsumos = 4
            MySQL.Async.fetchAll('SELECT consumos FROM vehicles WHERE model = @model',{['@model'] = carModel}, function(result)
                if result and result[1] ~= nil then
                    cb(randomFuel, result[1].consumos)
                else
                    cb(math.random(1,100), defaultConsumos)
                end
            end)
        end
    end)
end)


RegisterNetEvent('CarFuel:SaveFuel', function(fuel, plate)
    MySQL.Async.fetchAll('UPDATE owned_vehicles SET fuel = @fuel WHERE plate = @plate', {['@fuel'] = fuel, ['@plate'] = plate})
end)
