
# Removal for test.
[1,3,6].each do |i|
  Picture.where("device_id = #{i} and datediff(now(),dt) > 14").delete_all
end

# Removal based on default contract.
Temp.where("datediff(now(),dt) > 370").delete_all
Picture.where("datediff(now(),dt) > 94").delete_all