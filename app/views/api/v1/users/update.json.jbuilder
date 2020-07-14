json.user do
    json.extract! @user, :id, :email#, :permission_level
end
json.message t('users.updated', email: @user.email)
