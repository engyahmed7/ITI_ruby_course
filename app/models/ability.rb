class Ability
  include CanCan::Ability

  def initialize(user)
    can :read, Article, status: 'public'
    return unless user.present?
    can :create, Article
    can [:read, :update, :destroy], Article, user_id: user.id
    can :report, Article
  end
end
