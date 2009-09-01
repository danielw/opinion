namespace :db do
  namespace :backup do
    
  
    desc "Dump entire db."
    task :write => :environment do 

      dir = RAILS_ROOT + '/db/backup'
      FileUtils.mkdir_p(dir)
      FileUtils.chdir(dir)
    

      ActiveRecord::Base.connection.tables.sort.each do |tbl|
        next if ["schema_info", 'sessions'].flatten.any? do |ignored|
          case ignored
          when String: tbl == ignored
          when Regexp: tbl =~ ignored
          else
            raise StandardError, 'ActiveRecord::SchemaDumper.ignore_tables accepts an array of String and / or Regexp values.'
          end
        end 


        klass = tbl.classify.constantize
        puts "Writing #{tbl}..."
        File.open("#{tbl}.yml", 'w+') { |f| YAML.dump klass.find(:all).collect(&:attributes), f }      
      end
    
    end
  
    task :read => [:environment, 'db:schema:load'] do 

      dir = RAILS_ROOT + '/db/backup'
      FileUtils.mkdir_p(dir)
      FileUtils.chdir(dir)
    
      ActiveRecord::Base.connection.tables.sort.each do |tbl|
        next if ["schema_info", 'sessions', 'public_exceptions'].flatten.any? do |ignored|
          case ignored
          when String: tbl == ignored
          when Regexp: tbl =~ ignored
          else
            raise StandardError, 'ActiveRecord::SchemaDumper.ignore_tables accepts an array of String and / or Regexp values.'
          end
        end 
      
      
        klass = tbl.classify.constantize
        ActiveRecord::Base.transaction do 
        
          puts "Loading #{tbl}..."
          YAML.load_file("#{tbl}.yml").each { |fixture|
            ActiveRecord::Base.connection.execute "INSERT INTO #{tbl} (#{fixture.keys.join(",")}) VALUES (#{fixture.values.collect { |value| ActiveRecord::Base.connection.quote(value) }.join(",")})", 'Fixture Insert'
          }
        
        end
      end
    
    end
  
  end
end