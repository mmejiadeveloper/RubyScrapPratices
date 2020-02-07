class LoadStrategy
	def createFile (data)
		raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
	end
end