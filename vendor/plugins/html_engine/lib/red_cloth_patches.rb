require 'redcloth'

# We patch redcloth to get rid of the dreaded span and strikethrough syntax. 
class RedCloth
  remove_const('QTAGS')
  
  QTAGS = [
      ['*', 'strong'],
      ['_', 'em', :limit]
  ] 

  QTAGS.collect! do |rc, ht, rtype|
      rcq = Regexp::quote rc
      re =
          case rtype
          when :limit
              /(\W)
              (#{rcq})
              (#{C})
              (?::(\S+?))?
              (.+?)
              #{rcq}
              (?=\W)/x
          else
              /(#{rcq})
              (#{C})
              (?::(\S+?))?
              (.+?)
              #{rcq}/xm 
          end
      [rc, ht, re, rtype]
  end

  # Stub out the no textile method, it does weird things to == in forum posts
  def no_textile(text)
  end
  
end
