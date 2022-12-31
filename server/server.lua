ESX.RegisterServerCallback('CarFuel:GetInfoSV', function(source, cb, carPlate)

    MySQL.Async.fetchAll('SELECT fuel, consumos FROM owned_vehicles WHERE plate = @plate',{['@plate'] = carPlate}, function(result)
        if result then
            cb(result[1].fuel, result[1].consumos)
        end
    end)
end)


RegisterNetEvent('CarFuel:SaveFuel', function(fuel, plate)
    MySQL.Async.fetchAll('UPDATE owned_vehicles SET fuel = @fuel WHERE plate = @plate', {['@fuel'] = fuel, ['@plate'] = plate})
end)