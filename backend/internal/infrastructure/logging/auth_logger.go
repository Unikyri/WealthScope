package logging

import (
	"os"

	"go.uber.org/zap"
	"go.uber.org/zap/zapcore"
)

// AuthLogger provides structured logging for authentication events
type AuthLogger struct {
	logger *zap.Logger
}

// NewAuthLogger creates a new AuthLogger instance
func NewAuthLogger() (*AuthLogger, error) {
	// Configure encoder for JSON output
	encoderConfig := zapcore.EncoderConfig{
		TimeKey:        "timestamp",
		LevelKey:       "level",
		NameKey:        "logger",
		MessageKey:     "event",
		StacktraceKey:  "stacktrace",
		LineEnding:     zapcore.DefaultLineEnding,
		EncodeLevel:    zapcore.LowercaseLevelEncoder,
		EncodeTime:     zapcore.ISO8601TimeEncoder,
		EncodeDuration: zapcore.SecondsDurationEncoder,
		EncodeCaller:   zapcore.ShortCallerEncoder,
	}

	// Create core with JSON encoder
	core := zapcore.NewCore(
		zapcore.NewJSONEncoder(encoderConfig),
		zapcore.AddSync(os.Stdout),
		zap.InfoLevel,
	)

	logger := zap.New(core).Named("auth")

	return &AuthLogger{logger: logger}, nil
}

// NewAuthLoggerWithZap creates an AuthLogger from an existing zap.Logger
func NewAuthLoggerWithZap(logger *zap.Logger) *AuthLogger {
	return &AuthLogger{logger: logger.Named("auth")}
}

// LogLoginSuccess logs a successful login event
func (l *AuthLogger) LogLoginSuccess(userID, ip string) {
	l.logger.Info("login_success",
		zap.String("user_id", userID),
		zap.String("ip", ip),
	)
}

// LogLoginFailure logs a failed login attempt
func (l *AuthLogger) LogLoginFailure(email, ip, reason string) {
	l.logger.Warn("login_failure",
		zap.String("email", maskEmail(email)),
		zap.String("ip", ip),
		zap.String("reason", reason),
	)
}

// LogLogout logs a logout event
func (l *AuthLogger) LogLogout(userID, ip string) {
	l.logger.Info("logout",
		zap.String("user_id", userID),
		zap.String("ip", ip),
	)
}

// LogTokenRefresh logs a token refresh event
func (l *AuthLogger) LogTokenRefresh(userID string) {
	l.logger.Debug("token_refresh",
		zap.String("user_id", userID),
	)
}

// LogRateLimitHit logs when rate limit is exceeded
func (l *AuthLogger) LogRateLimitHit(ip, endpoint string) {
	l.logger.Warn("rate_limit_hit",
		zap.String("ip", ip),
		zap.String("endpoint", endpoint),
	)
}

// LogAuthError logs authentication errors
func (l *AuthLogger) LogAuthError(operation, ip, errorMsg string) {
	l.logger.Error("auth_error",
		zap.String("operation", operation),
		zap.String("ip", ip),
		zap.String("error", errorMsg),
	)
}

// Sync flushes any buffered log entries
func (l *AuthLogger) Sync() error {
	return l.logger.Sync()
}

// maskEmail partially masks an email address for privacy in logs
func maskEmail(email string) string {
	if len(email) < 5 {
		return "***"
	}

	// Find @ position
	atIndex := -1
	for i, c := range email {
		if c == '@' {
			atIndex = i
			break
		}
	}

	if atIndex <= 2 {
		return "***" + email[atIndex:]
	}

	// Show first 2 chars, mask rest before @
	return email[:2] + "***" + email[atIndex:]
}
