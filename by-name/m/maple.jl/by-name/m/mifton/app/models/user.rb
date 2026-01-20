class User < ApplicationRecord
  has_one_attached :icon
  has_one_attached :header

  has_one :user_traffic, dependent: :destroy
  has_one :user_birthday, dependent: :destroy
  has_one :authority, dependent: :destroy
  has_many :rating, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :contest_records, dependent: :destroy
  has_many :microposts, dependent: :destroy
  has_many :topics, dependent: :destroy
  has_many :contest_join_users, dependent: :destroy
  has_many :reports
  has_many :notifications, dependent: :destroy
  has_many :direct_messages, dependent: :destroy

  has_secure_password

  has_many :active_relationships, class_name:  "Relationship",
                                  foreign_key: "follower_id",
                                  dependent:   :destroy
  has_many :following, through: :active_relationships, source: :followed

  has_many :passive_relationships, class_name:  "Relationship",
                                   foreign_key: "followed_id",
                                   dependent:   :destroy
  has_many :followers, through: :passive_relationships, source: :follower

  # モデルバリデーション BEGIN

    # User_ID 必須入力/3文字以上15文字以下/重複不可
    before_save { self.user_id = user_id.downcase }
    VALID_USER_ID_REGEX = /[a-z]+[a-z_0-9]/
    validates :user_id, presence: true, length: { in: 3..15 }, uniqueness: true, format: { with: VALID_USER_ID_REGEX }

    # password
    validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

    # email
    before_save { self.email = email.downcase }
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    validates :email, presence: true, length: { maximum: 255 },
              format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }

    # nick_name
    validates :name, presence: true, length: { maximum: 50 }

  # モデルバリデーション END

  def follow(other_user)
    active_relationships.create(followed_id: other_user.id)
  end

  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  def following?(other_user)
    following.include?(other_user)
  end

  def self.find_or_create_from_auth_hash(auth)
    user = User.where(uid: auth.uid, provider: auth.provider).first


    unless user
      user = User.new(
        uid:      auth.uid,
        provider: auth.provider,
        email:    User.dummy_email(auth),
        password: ((0..9).to_a + ("a".."z").to_a).sample(15).join,
        name: auth.info.name,
        location: auth.info.location,
        user_id: self.generate_user_id(auth)
      )

      user.save

      authority = user.build_authority
      authority.save

      user_traffic = user.build_user_traffic
      user_traffic.save
    end

    return user
  end

  private

  def self.dummy_email(auth)
    "#{auth.uid}-#{auth.provider}@example.com"
  end

  def self.generate_user_id(auth)
    if User.find_by(user_id: auth.uid)
      auth.uid
    else
      ((0..9).to_a + ("a".."z").to_a).sample(10).join
    end
  end

end
