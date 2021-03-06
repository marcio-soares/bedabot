module LinkModule
  class ListService
    def initialize(params, action)
      # TODO: identify origin and set company
      @company = Company.last
      @action = action
      @query = params["query"]
    end
    
    def call
      if @action == 'search_link'
        links = Link.search(@query).where(company: @company)   
      elsif @action == 'search_link_by_tag'
        links = @company.hashtags.search(@query).map(&:links).flatten
      else
        links = @company.links        
      end
      response = nil
      if links.count > 0
        response = "Links encontrados \n"    
        links.each do |link|
          response << ">*#{link.id}* - <#{link.url}> "
          response << "> #{link.description}" if link.description
          response << "\n"
          link.hashtags.each do |tag|
            response << "_##{tag.name}_ \n"
          end
        end
      end
      response.blank? ? ["Nada encontrado", "Nenhum Link encontrado", "Não encontramos nada", "Sua busca não teve resultado"].sample : response
    end
  end
end