# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    if !user.nil?
      can [:create, :read], [Profile,Note]
      #indicamos que puede actualizar y leer profile y notas
      #cuando el user_id corresponda al usuario logueado
      can [:update,:read], [Profile,Note], {user_id: user.id}
      cannot [:destroy], [Profile]
      can [:destroy], [Note], {user_id: user.id}
    end
  end
end
