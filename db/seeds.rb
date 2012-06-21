
puts "Creating a pairing."
seed_pairing = Pairing.create({ :formed => '2012-06-15 9:00:00'.to_datetime})

puts "Creating participants."
participant1 = Participant.create({ :code => 'XT69W3'+DateTime.now.to_i.to_s, :joined => DateTime.now, :last_contact => nil})
participant2 = Participant.create({ :code => 'AG004R'+DateTime.now.to_i.to_s, :joined => DateTime.now, :last_contact => nil})
participant3 = Participant.create({ :code => '83FY32'+DateTime.now.to_i.to_s, :joined => DateTime.now, :last_contact => nil})

puts "Putting participants in a pairing."
participant1.update_attributes({:pairing_id => seed_pairing.id, :pairing_role =>1})
participant2.update_attributes({:pairing_id => seed_pairing.id, :pairing_role =>2})

puts "Creating messages."
Message.create({:participant_id => participant1.id, :body => "Hey hows it going."})
Message.create({:participant_id => participant2.id, :body => "Hello, how are you, sir or madam."})





