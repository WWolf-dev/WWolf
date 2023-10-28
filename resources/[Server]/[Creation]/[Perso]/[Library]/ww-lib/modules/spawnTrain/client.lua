---@param spawnTrain table The table containing the train data.

---@param switchTrainTrack table The table containing the switch train track data.
---@param trackID number The track ID.
---@param state boolean The state of the track.

---@param trainTrackSpawnFrequency table The table containing the train track spawn frequency data.
---@param trackID number The track ID.
---@param frequency number The frequency of the track.

---@param randomTrain boolean Is the train random.

function ww.spawnTrain(data)
    -- S'assure que 'switchTrainTrack' et 'trainTrackSpawnFrequency' existe
    if data.switchTrainTrack then
        for _, trackData in pairs(data.switchTrainTrack) do
            if trackData.trackID and trackData.state ~= nil then
                SwitchTrainTrack(trackData.trackID, trackData.state)
            end
        end
    end

    if data.trainTrackSpawnFrequency then
        for _, frequencyData in pairs(data.trainTrackSpawnFrequency) do
            if frequencyData.trackID and frequencyData.frequency then
                SetTrainTrackSpawnFrequency(frequencyData.trackID, frequencyData.frequency)
            end
        end
    end

    SetRandomTrains(data.randomTrain or false)
end

return ww.spawnTrain